# Irrigation Monitoring System
![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Version](https://img.shields.io/badge/version-1.0.0-green.svg)

## Table of Contents
1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [System Architecture](#system-architecture)
4. [Local Development Setup](#local-development-setup)
5. [Infrastructure Deployment](#infrastructure-deployment)
6. [Application Deployment](#application-deployment)
7. [Mobile App Building](#mobile-app-building)
8. [Monitoring and Maintenance](#monitoring-and-maintenance)
9. [Troubleshooting](#troubleshooting)
10. [Security Considerations](#security-considerations)
11. [Contributing](#contributing)

## Overview
A comprehensive irrigation monitoring and management system that includes:
- Backend API services
- Infrastructure automation
- Monitoring and alerting
- Single Page Application (SPA) for real-time monitoring

## Features
- Real-time monitoring and control
- Automated deployment pipeline
- Infrastructure as Code with Terraform
- Containerized services with Docker
- Comprehensive logging and monitoring
- **New: Interactive SPA Dashboard**

## Single Page Application
The new SPA provides a modern, responsive interface for:
- Real-time dashboard monitoring
- Interactive station management
- Visual inspection calendar
- Advanced reporting interface
- Responsive design for all devices

### SPA Technical Stack
- React 18+
- TypeScript
- Redux Toolkit
- React Native Paper
- Recharts for visualization

### SPA Setup
```bash
# Navigate to the SPA directory
cd frontend

# Install dependencies
npm install

# Start development server
npm start

# Build for production
npm run build
```

## Prerequisites

### Infrastructure

#### Prerequisites
- Azure Subscription with appropriate permissions
- Terraform >= 1.0.0
- Docker
- Node.js >= 18.0.0

#### Required Software
```bash
# Install Node.js (v18 or later)
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Install Terraform
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform
```

### Required Accounts and Subscriptions
- Azure Subscription
- GitHub Account
- Apple Developer Account (for iOS deployment)
- Google Play Developer Account (for Android deployment)

## System Architecture

### Infrastructure Components
```
├── Backend (Node.js/Express)
│   ├── API Services
│   ├── Authentication
│   └── Database Integration
├── Frontend (React Native)
│   ├── Mobile Apps
│   └── Admin Dashboard
└── Infrastructure (Azure)
    ├── App Service
    ├── SQL Database
    ├── Storage Account
    └── Application Insights
```

### Database Schema
```sql
-- Users Table
CREATE TABLE Users (
    id UUID PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Properties Table
CREATE TABLE Properties (
    id UUID PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    address TEXT NOT NULL,git brna
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Stations Table
CREATE TABLE Stations (
    id UUID PRIMARY KEY,
    property_id UUID REFERENCES Properties(id),
    station_number VARCHAR(50) UNIQUE NOT NULL,
    address TEXT NOT NULL,
    controller_details JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Inspections Table
CREATE TABLE Inspections (
    id UUID PRIMARY KEY,
    station_id UUID REFERENCES Stations(id),
    engineer_id UUID REFERENCES Users(id),
    status VARCHAR(50) NOT NULL,
    gps_coordinates POINT,
    inspection_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_locked BOOLEAN DEFAULT false
);

-- Repairs Table
CREATE TABLE Repairs (
    id UUID PRIMARY KEY,
    inspection_id UUID REFERENCES Inspections(id),
    part_id UUID REFERENCES Parts(id),
    workorder_number VARCHAR(50),
    invoice_url TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## Local Development Setup

1. Clone and Setup:
```bash
# Clone the repository
git clone https://github.com/your-org/irrigation-monitoring.git
cd irrigation-monitoring

# Install dependencies
npm install

# Create environment files
cp .env.example .env
```

2. Environment Configuration:
```bash
# API Configuration
API_URL=https://your-api-url.com
API_VERSION=v1

# Azure Configuration
AZURE_STORAGE_CONNECTION_STRING=your_connection_string
AZURE_AD_CLIENT_ID=your_client_id
AZURE_AD_TENANT_ID=your_tenant_id

# JWT Configuration
JWT_SECRET=your_jwt_secret
JWT_EXPIRY=24h

# Database Configuration
DB_HOST=your_db_host
DB_NAME=your_db_name
DB_USER=your_db_user
DB_PASSWORD=your_db_password

# Push Notifications
PUSH_NOTIFICATION_KEY=your_push_key
```

## Infrastructure Deployment

### Terraform Configuration

1. Main Configuration (terraform/main.tf):
```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "terraform-state-rg"
    storage_account_name = "tfstate${random_string.storage_account_suffix.result}"
    container_name      = "tfstate"
    key                 = "prod.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "${var.project_name}-${var.environment}-rg"
  location = var.location
  tags     = var.common_tags
}
```

2. Database Configuration (terraform/database.tf):
```hcl
resource "azurerm_sql_server" "main" {
  name                         = "${var.project_name}-${var.environment}-sql"
  resource_group_name         = azurerm_resource_group.main.name
  location                    = azurerm_resource_group.main.location
  version                     = "12.0"
  administrator_login         = var.db_admin_username
  administrator_login_password = var.db_admin_password

  tags = var.common_tags
}

resource "azurerm_sql_database" "main" {
  name                = "${var.project_name}-${var.environment}-db"
  resource_group_name = azurerm_resource_group.main.name
  location           = azurerm_resource_group.main.location
  server_name        = azurerm_sql_server.main.name
  edition            = "Standard"
  
  tags = var.common_tags
}
```

3. App Service Configuration (terraform/app_service.tf):
```hcl
resource "azurerm_app_service_plan" "main" {
  name                = "${var.project_name}-${var.environment}-asp"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Standard"
    size = "S1"
  }

  tags = var.common_tags
}

resource "azurerm_app_service" "api" {
  name                = "${var.project_name}-${var.environment}-api"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  app_service_plan_id = azurerm_app_service_plan.main.id

  site_config {
    linux_fx_version = "NODE|18-lts"
    always_on        = true
  }

  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
    "WEBSITE_NODE_DEFAULT_VERSION"        = "~18"
    "DATABASE_URL"                        = "Server=tcp:${azurerm_sql_server.main.fully_qualified_domain_name},1433;Database=${azurerm_sql_database.main.name};User ID=${var.db_admin_username};Password=${var.db_admin_password};Encrypt=true"
    "JWT_SECRET"                          = var.jwt_secret
    "NODE_ENV"                           = var.environment
  }

  tags = var.common_tags
}
```

## Application Deployment

### Backend Deployment Script (scripts/deploy.sh):
```bash
#!/bin/bash
set -e

# Load environment variables
source .env

# Initialize Terraform
cd terraform
terraform init

# Apply Terraform configuration
terraform apply -auto-approve \
  -var="environment=${ENVIRONMENT}" \
  -var="db_admin_username=${DB_ADMIN_USERNAME}" \
  -var="db_admin_password=${DB_ADMIN_PASSWORD}" \
  -var="jwt_secret=${JWT_SECRET}"

# Get outputs
APP_SERVICE_NAME=$(terraform output -raw app_service_name)
RESOURCE_GROUP=$(terraform output -raw resource_group_name)

# Build and deploy backend
cd ../backend
npm install
npm run build

# Deploy to Azure App Service
zip -r ../deployment.zip ./*
az webapp deployment source config-zip \
  --resource-group $RESOURCE_GROUP \
  --name $APP_SERVICE_NAME \
  --src ../deployment.zip

# Clean up
rm ../deployment.zip
```

### Database Initialization Script (scripts/init-database.sh):
```bash
#!/bin/bash
set -e

# Load environment variables
source .env

# Get database connection string
cd terraform
DB_CONNECTION_STRING=$(terraform output -raw database_connection_string)
cd ..

# Run database migrations
psql "$DB_CONNECTION_STRING" -f database/schema.sql

# Seed initial data if needed
psql "$DB_CONNECTION_STRING" -f database/seed.sql
```

## Mobile App Building

### Android Setup
```bash
# Open Android Studio and configure SDK
cd android
./gradlew clean
./gradlew assembleRelease

# Generate release keystore
keytool -genkey -v -keystore my-release-key.keystore \
    -alias my-key-alias \
    -keyalg RSA \
    -keysize 2048 \
    -validity 10000
```

### iOS Setup (Mac only)
```bash
# Install iOS dependencies
cd ios
pod install

# Open Xcode workspace
open YourApp.xcworkspace

# Build using Xcode Command Line
xcodebuild -workspace YourApp.xcworkspace \
    -scheme YourApp \
    -configuration Release \
    -derivedDataPath build
```

## Monitoring and Maintenance

### Azure Monitoring Setup
```bash
# Create Application Insights
az monitor app-insights component create \
    --app your-app-name \
    --location eastus \
    --resource-group your-resource-group

# Monitor logs
az webapp log tail \
    --name your-app-name \
    --resource-group your-resource-group

# Create alert rule
az monitor metrics alert create \
    --name "High CPU Usage" \
    --resource-group your-resource-group \
    --scopes your-app-service-id \
    --condition "CPU Percentage > 80" \
    --window-size 5m \
    --evaluation-frequency 1m
```

### Backup Procedures
```bash
# Database backup
az sql db export \
    --resource-group your-resource-group \
    --server your-server \
    --name your-database \
    --admin-user your-admin \
    --admin-password your-password \
    --storage-key your-storage-key \
    --storage-key-type StorageAccessKey \
    --storage-uri your-storage-uri

# Storage backup
az storage blob copy start-batch \
    --source-container source \
    --destination-container backup \
    --account-name your-storage-account
```

## Troubleshooting

### Common Issues and Solutions

1. Database Connection Issues:
```bash
# Check firewall rules
az sql server firewall-rule list \
    --resource-group your-resource-group \
    --server your-server

# Test connection
psql -h your-server.database.windows.net -U your-username -d your-database
```

2. Mobile Build Issues:
```bash
# Clear React Native cache
npm start -- --reset-cache

# Clear Android build
cd android
./gradlew clean

# Clear iOS build (Mac only)
cd ios
pod deintegrate
pod install
```

3. Deployment Issues:
```bash
# Check deployment logs
az webapp log tail

# Verify environment variables
az webapp config appsettings list \
    --resource-group your-resource-group \
    --name your-app-name
```

## Security Considerations

### Infrastructure Security
```bash
# Enable Azure Security Center
az security center pricing create \
    --name "default" \
    --tier "Standard" \
    --resource-group your-resource-group

# Configure firewall rules
az network firewall create \
    --name app-firewall \
    --resource-group your-resource-group \
    --location your-location
```

### Application Security
```typescript
// JWT Configuration
const authMiddleware = (req: Request, res: Response, next: NextFunction) => {
  try {
    const token = req.headers.authorization?.split(' ')[1];
    if (!token) throw new Error('No token provided');
    
    const decoded = jwt.verify(token, process.env.JWT_SECRET!);
    req.user = decoded;
    next();
  } catch (error) {
    res.status(401).json({ message: 'Authentication failed' });
  }
};

// Data Encryption
const encryptData = (data: string): string => {
  const cipher = crypto.createCipher('aes-256-cbc', process.env.ENCRYPTION_KEY!);
  return cipher.update(data, 'utf8', 'hex') + cipher.final('hex');
};
```

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

- Technical Support: support@yourcompany.com
- Documentation: [Wiki](link-to-wiki)
- Issue Tracker: [GitHub Issues](link-to-issues)

## Authors

- Your Name - Initial work - [YourGitHub](https://github.com/yourusername)

## Acknowledgments

- Azure Cloud Services
- React Native Community
- Terraform
- Node.js Community

---

**Note**: Remember to replace placeholder values (your-org, your-resource-group, etc.) with your actual values before using this README.

## Development Workflow

### Backend Development
[... existing backend development sections remain unchanged ...]

### SPA Development
```bash
# Start development server
npm start

# Run tests
npm test

# Run linting
npm run lint

# Format code
npm run format
```

### Code Quality
- ESLint configuration
- Prettier formatting
- TypeScript strict mode
- Component documentation

## Additional Documentation

### SPA Architecture
- Component-based architecture
- State management with Redux
- API integration patterns
- Responsive design implementation

### SPA Features
1. Dashboard
   - Real-time monitoring
   - Key metrics display
   - Interactive charts

2. Properties Management
   - Property listing
   - Detail views
   - Edit capabilities

3. Stations
   - Status monitoring
   - Configuration
   - Maintenance tracking

4. Inspections
   - Calendar view
   - Form management
   - Status tracking

5. Reports
   - Custom report generation
   - Data export
   - Visual analytics
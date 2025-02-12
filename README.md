# Irrigation Monitoring System

A full-stack application for managing irrigation systems, built with React, Node.js, and PostgreSQL.

## Table of Contents
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Local Development Setup](#local-development-setup)
- [Environment Configuration](#environment-configuration)
- [Database Setup](#database-setup)
- [Running Tests](#running-tests)
- [Infrastructure Setup](#infrastructure-setup)
- [Deployment](#deployment)
- [Monitoring and Logging](#monitoring-and-logging)
- [Security Considerations](#security-considerations)
- [API Documentation](#api-documentation)
- [Contributing](#contributing)
- [Troubleshooting](#troubleshooting)

## Features

### Core Features
- User authentication and role-based access control
- Property and irrigation station management
- Inspection records and repair documentation
- Real-time monitoring dashboard
- Mobile-responsive design
- Secure API with rate limiting and JWT authentication

### Technical Features
- TypeScript for enhanced type safety
- React with modern hooks and context
- Express.js backend with middleware architecture
- PostgreSQL database with Prisma ORM
- Redis for caching and rate limiting
- WebSocket for real-time updates
- Comprehensive test coverage
- CI/CD pipeline with GitHub Actions

## Prerequisites

### Required Software
- Node.js (v16 or higher)
- PostgreSQL (v14 or higher)
- Redis (v6 or higher)
- Docker and Docker Compose
- Git

### Cloud Services
- AWS Account with required permissions
- AWS CLI configured
- Domain name (for production)
- SSL certificate

## Local Development Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/your-org/irrigation-system.git
   cd irrigation-system
   ```

2. Install dependencies:
   ```bash
   # Install backend dependencies
   cd backend
   npm install

   # Install frontend dependencies
   cd ../frontend
   npm install
   ```

3. Set up environment files:
   ```bash
   # Backend environment
   cp .env.example .env

   # Frontend environment
   cp .env.example .env.local
   ```

4. Start development servers:
   ```bash
   # Start all services using Docker Compose
   docker-compose up -d

   # Or start services individually:
   # Backend
   cd backend
   npm run dev

   # Frontend
   cd frontend
   npm start
   ```

## Environment Configuration

Configure the following environment variables in your `.env` file:

### Required Variables
- `NODE_ENV`: Application environment (development/production)
- `PORT`: Backend server port
- `DB_HOST`: PostgreSQL host
- `DB_NAME`: Database name
- `DB_USER`: Database user
- `DB_PASSWORD`: Database password
- `JWT_SECRET`: Secret key for JWT tokens
- `REACT_APP_API_URL`: Frontend API URL

### Optional Variables
- `REDIS_HOST`: Redis host (for rate limiting)
- `SENTRY_DSN`: Sentry error tracking
- `AWS_ACCESS_KEY_ID`: AWS credentials
- `AWS_SECRET_ACCESS_KEY`: AWS credentials
- `AWS_REGION`: AWS region

## Database Setup

1. Create the database:
   ```bash
   createdb irrigation_db
   ```

2. Run migrations:
   ```bash
   cd database
   psql -d irrigation_db -f schema.sql
   ```

## Running Tests

```bash
# Run backend tests
cd backend
npm test

# Run frontend tests
cd frontend
npm test
```

## Infrastructure Setup

### Database Infrastructure

#### AWS RDS Configuration

The project uses AWS RDS with enhanced security and monitoring:

1. **Encryption and Security**:
   ```hcl
   resource "aws_db_instance" "postgres" {
     # Encryption settings
     storage_encrypted      = true
     kms_key_id            = aws_kms_key.rds.arn
     
     # Performance insights with encryption
     performance_insights_enabled = true
     performance_insights_retention_period = var.environment == "production" ? 731 : 7
     performance_insights_kms_key_id = aws_kms_key.rds.arn
   }
   ```

2. **Monitoring and Logging**:
   - Enhanced monitoring with 60-second intervals
   - Performance Insights enabled
   - CloudWatch log exports for PostgreSQL and upgrades
   - Automated query performance tracking

3. **High Availability**:
   - Multi-AZ deployment in production
   - Automated backups with 35-day retention in production
   - Final snapshot creation on deletion
   - Storage auto-scaling configuration

4. **Security Groups and Networking**:
   - VPC-based deployment
   - Private subnet placement
   - Restricted security group access
   - Encrypted communication

#### Azure SQL Database Configuration

The Azure SQL Database setup includes comprehensive security and monitoring:

1. **Authentication and Access**:
   ```hcl
   resource "azurerm_sql_server" "main" {
     # Azure AD authentication
     azuread_administrator {
       login_username = var.azure_ad_admin_username
       object_id     = var.azure_ad_admin_object_id
     }
   }
   ```

2. **Network Security**:
   - Private endpoint configuration
   - Network rules for storage accounts
   - IP-based firewall rules
   - Azure services access control

3. **Monitoring and Diagnostics**:
   - Log Analytics integration
   - Automatic tuning enabled
   - Query store monitoring
   - Advanced threat protection

4. **Data Protection**:
   - Transparent data encryption
   - Geo-redundant backups in production
   - Vulnerability assessments
   - Security alerts and auditing

### Environment-Specific Configurations

Both cloud providers use environment-specific settings:

#### Production Environment
- Extended backup retention (35 days)
- Higher performance tiers
- Multi-AZ/Zone redundancy
- Enhanced monitoring retention

#### Development Environment
- Standard performance tiers
- Local redundancy
- Basic monitoring
- Shorter backup retention (7 days)

### Security Features

1. **Encryption**:
   - At-rest encryption using KMS/Azure Key Vault
   - In-transit encryption using TLS 1.2
   - Performance Insights encryption
   - Backup encryption

2. **Access Control**:
   - IAM/Azure AD integration
   - Role-based access control
   - Network isolation
   - Firewall rules

3. **Monitoring**:
   - Real-time performance monitoring
   - Security event logging
   - Audit logging
   - Automated vulnerability scanning

4. **Compliance**:
   - Automated backup retention
   - Encryption compliance
   - Access logging
   - Security alerting

### Deployment Instructions

1. **AWS Deployment**:
   ```bash
   cd terraform/aws
   terraform init
   terraform plan
   terraform apply
   ```

2. **Azure Deployment**:
   ```bash
   cd terraform/azure
   terraform init
   terraform plan
   terraform apply
   ```

### Required Variables

Create a `terraform.tfvars` file with the following variables:

```hcl
# Common
environment = "production"
project_name = "irrigation"

# AWS
aws_region = "us-east-1"
db_instance_class = "db.t3.small"
db_allocated_storage = 20
db_max_allocated_storage = 100

# Azure
location = "eastus"
allowed_ip_addresses = ["YOUR_IP"]
security_alert_emails = ["alerts@yourdomain.com"]
```

## Deployment

### Development Deployment

1. Using Docker Compose:
   ```bash
   # Build and start all services
   docker-compose -f docker-compose.dev.yml up --build

   # View logs
   docker-compose logs -f
   ```

### Production Deployment

1. Build and Push Docker Images:
   ```bash
   # Login to ECR
   aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com

   # Build images
   docker build -t irrigation-api ./backend
   docker build -t irrigation-frontend ./frontend

   # Tag and push
   docker tag irrigation-api:latest $AWS_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/irrigation-api:latest
   docker tag irrigation-frontend:latest $AWS_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/irrigation-frontend:latest

   docker push $AWS_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/irrigation-api:latest
   docker push $AWS_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/irrigation-frontend:latest
   ```

2. Deploy to ECS:
   ```bash
   # Update ECS services
   aws ecs update-service --cluster irrigation-cluster --service irrigation-api --force-new-deployment
   aws ecs update-service --cluster irrigation-cluster --service irrigation-frontend --force-new-deployment
   ```

### Database Migrations

1. Initial Setup:
   ```bash
   # Run initial migration
   cd backend
   npm run migrate:up
   ```

2. Production Migration:
   ```bash
   # Create migration
   npm run migrate:create

   # Apply migration
   NODE_ENV=production npm run migrate:up
   ```

## Monitoring and Logging

### Setup Monitoring

1. CloudWatch Configuration:
   ```bash
   # Install CloudWatch agent
   aws ssm send-command \
     --document-name "AWS-ConfigureAWSPackage" \
     --parameters '{"action":["Install"],"name":["AmazonCloudWatchAgent"]}' \
     --targets "Key=tag:Environment,Values=production"
   ```

2. Logging Configuration:
   ```json
   {
     "logs": {
       "logs_collected": {
         "files": {
           "collect_list": [
             {
               "file_path": "/var/log/application.log",
               "log_group_name": "/irrigation/application",
               "log_stream_name": "{instance_id}"
             }
           ]
         }
       }
     }
   }
   ```

### Alerts and Notifications

1. Set up CloudWatch Alarms:
   ```bash
   aws cloudwatch put-metric-alarm \
     --alarm-name cpu-utilization \
     --alarm-description "CPU utilization exceeded 80%" \
     --metric-name CPUUtilization \
     --namespace AWS/ECS \
     --statistic Average \
     --period 300 \
     --threshold 80 \
     --comparison-operator GreaterThanThreshold \
     --evaluation-periods 2 \
     --alarm-actions arn:aws:sns:region:account-id:notification-topic
   ```

## Security Considerations

### Application Security
- JWT-based authentication
- Role-based access control
- Input validation and sanitization
- Rate limiting
- CORS configuration
- Security headers (Helmet)
- SQL injection prevention
- XSS protection

### Infrastructure Security
- VPC security groups
- Network ACLs
- SSL/TLS encryption
- Regular security updates
- Automated vulnerability scanning
- Secure secret management
- Regular backups

## Troubleshooting

### Common Issues

1. Database Connection Issues:
   ```bash
   # Check database connectivity
   pg_isready -h $DB_HOST -p $DB_PORT -U $DB_USER

   # View database logs
   docker-compose logs db
   ```

2. Container Issues:
   ```bash
   # View container logs
   docker logs <container_id>

   # Check container status
   docker ps -a
   ```

3. Deployment Issues:
   ```bash
   # Check ECS service status
   aws ecs describe-services --cluster irrigation-cluster --services irrigation-api

   # View CloudWatch logs
   aws logs get-log-events --log-group-name /ecs/irrigation-api --log-stream-name <stream-name>
   ```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

### Development Workflow
1. Create branch from develop
2. Make changes
3. Run tests and linting
4. Create PR
5. Code review
6. Merge to develop
7. Deploy to staging
8. QA testing
9. Merge to main
10. Deploy to production

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

## Docker Configuration

### Project Structure
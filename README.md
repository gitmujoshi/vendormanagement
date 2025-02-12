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

### AWS Infrastructure (Using Terraform)

1. Initialize Terraform:
   ```bash
   cd terraform
   terraform init
   ```

2. Configure AWS Provider:
   ```hcl
   # terraform/provider.tf
   provider "aws" {
     region = "us-east-1"
     # Additional provider configuration
   }
   ```

3. Create VPC and Networking:
   ```hcl
   # terraform/network.tf
   module "vpc" {
     source = "terraform-aws-modules/vpc/aws"
     
     name = "irrigation-vpc"
     cidr = "10.0.0.0/16"
     
     azs             = ["us-east-1a", "us-east-1b"]
     private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
     public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
     
     enable_nat_gateway = true
     single_nat_gateway = true
   }
   ```

4. Set up ECS Cluster:
   ```hcl
   # terraform/ecs.tf
   resource "aws_ecs_cluster" "main" {
     name = "irrigation-cluster"
     
     setting {
       name  = "containerInsights"
       value = "enabled"
     }
   }
   ```

5. Create RDS Instance:
   ```hcl
   # terraform/database.tf
   resource "aws_db_instance" "postgres" {
     identifier        = "irrigation-db"
     engine           = "postgres"
     engine_version   = "14"
     instance_class   = "db.t3.micro"
     allocated_storage = 20
     
     db_name  = "irrigation_db"
     username = var.db_username
     password = var.db_password
     
     backup_retention_period = 7
     multi_az               = false
     skip_final_snapshot    = true
     
     vpc_security_group_ids = [aws_security_group.rds.id]
     db_subnet_group_name   = aws_db_subnet_group.main.name
   }
   ```

6. Apply Infrastructure:
   ```bash
   terraform plan
   terraform apply
   ```

### Container Registry Setup

1. Create ECR Repositories:
   ```bash
   aws ecr create-repository --repository-name irrigation-api
   aws ecr create-repository --repository-name irrigation-frontend
   ```

2. Configure GitHub Actions for ECR Access:
   ```yaml
   # Add to repository secrets
   AWS_ACCESS_KEY_ID: your-access-key
   AWS_SECRET_ACCESS_KEY: your-secret-key
   AWS_REGION: us-east-1
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
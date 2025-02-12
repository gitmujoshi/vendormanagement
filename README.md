# Irrigation Monitoring System

A full-stack application for managing irrigation systems, built with React, Node.js, and PostgreSQL.

## Table of Contents
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Local Development Setup](#local-development-setup)
- [Environment Configuration](#environment-configuration)
- [Database Setup](#database-setup)
- [Running Tests](#running-tests)
- [Deployment](#deployment)
- [Infrastructure Setup](#infrastructure-setup)
- [Monitoring and Logging](#monitoring-and-logging)
- [Security Considerations](#security-considerations)
- [API Documentation](#api-documentation)

## Features

- User authentication and role-based access control
- Property and irrigation station management
- Inspection records and repair documentation
- Real-time monitoring dashboard
- Mobile-responsive design
- Secure API with rate limiting and JWT authentication

## Prerequisites

- Node.js (v16 or higher)
- PostgreSQL (v14 or higher)
- Docker and Docker Compose
- AWS CLI (for deployment)
- Git

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

3. Create environment files:
   ```bash
   cp .env.example .env
   ```

4. Start the development servers:
   ```bash
   # Start backend (from backend directory)
   npm run dev

   # Start frontend (from frontend directory)
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

## Deployment

### Using Docker Compose (Development)

```bash
docker-compose up --build
```

### Production Deployment (AWS)

1. Configure AWS credentials:
   ```bash
   aws configure
   ```

2. Create ECR repositories:
   ```bash
   aws ecr create-repository --repository-name irrigation-api
   aws ecr create-repository --repository-name irrigation-frontend
   ```

3. Build and push Docker images:
   ```bash
   # Login to ECR
   aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com

   # Build and push images
   docker-compose -f docker-compose.prod.yml build
   docker-compose -f docker-compose.prod.yml push
   ```

4. Deploy to ECS:
   ```bash
   aws ecs update-service --cluster irrigation-cluster --service irrigation-api --force-new-deployment
   aws ecs update-service --cluster irrigation-cluster --service irrigation-frontend --force-new-deployment
   ```

## Infrastructure Setup

### AWS Resources Required

1. **VPC Configuration**:
   - Create VPC with public and private subnets
   - Set up NAT Gateway and Internet Gateway
   - Configure route tables

2. **ECS Cluster**:
   - Create ECS cluster
   - Set up task definitions for API and frontend
   - Configure services with load balancers

3. **RDS Database**:
   - Create PostgreSQL RDS instance
   - Configure security groups
   - Set up automated backups

4. **Load Balancers**:
   - Application Load Balancer for frontend
   - Application Load Balancer for API
   - Configure SSL certificates

5. **Security Groups**:
   - Frontend ALB security group
   - API ALB security group
   - ECS tasks security group
   - RDS security group

### Terraform Setup

Infrastructure is managed using Terraform. See `terraform/` directory for configuration files.

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

## Monitoring and Logging

### Setup Monitoring

1. **CloudWatch**:
   - Configure CloudWatch agent
   - Set up log groups
   - Create dashboards and alarms

2. **Sentry**:
   - Add Sentry DSN to environment variables
   - Configure error tracking

3. **New Relic**:
   - Install New Relic agent
   - Configure APM monitoring

### Log Management

- Application logs are stored in CloudWatch Logs
- Database logs are stored in RDS logs
- Load balancer logs are stored in S3

## Security Considerations

1. **Authentication**:
   - JWT tokens with expiration
   - Secure password hashing
   - Role-based access control

2. **API Security**:
   - Rate limiting
   - CORS configuration
   - Input validation
   - SQL injection protection

3. **Infrastructure Security**:
   - VPC security groups
   - Network ACLs
   - SSL/TLS encryption
   - Regular security updates

## API Documentation

API documentation is available at `/api/docs` when running the server.

For detailed API documentation, see [API.md](./API.md).

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

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
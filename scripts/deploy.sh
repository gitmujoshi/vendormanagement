    #!/bin/bash
# @file deploy.sh
# @description Main deployment script for the application

set -e

# Load environment variables
source .env

# Initialize Terraform
echo "Initializing Terraform..."
cd terraform
terraform init

# Apply Terraform configuration
echo "Applying Terraform configuration..."
terraform apply -auto-approve \
  -var="environment=${ENVIRONMENT}" \
  -var="db_admin_username=${DB_ADMIN_USERNAME}" \
  -var="db_admin_password=${DB_ADMIN_PASSWORD}" \
  -var="jwt_secret=${JWT_SECRET}"

# Get outputs
APP_SERVICE_NAME=$(terraform output -raw app_service_name)
RESOURCE_GROUP=$(terraform output -raw resource_group_name)

# Build and deploy backend
echo "Building backend..."
cd ../backend
npm install
npm run build

# Deploy to Azure App Service
echo "Deploying to Azure App Service..."
zip -r ../deployment.zip ./*
az webapp deployment source config-zip \
  --resource-group $RESOURCE_GROUP \
  --name $APP_SERVICE_NAME \
  --src ../deployment.zip

# Clean up
rm ../deployment.zip

echo "Deployment completed successfully!" 
#!/bin/bash

# Exit on error
set -e

# Check if Azure CLI is installed and logged in
if ! command -v az &> /dev/null; then
    echo "Error: Azure CLI is not installed"
    echo "Please install Azure CLI: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli"
    exit 1
fi

# Check if logged in to Azure
if ! az account show &> /dev/null; then
    echo "Error: Not logged in to Azure"
    echo "Please run 'az login' first"
    exit 1
fi

# Check if required environment variables are set
if [ -z "$TF_VAR_db_admin_username" ] || [ -z "$TF_VAR_db_admin_password" ] || [ -z "$TF_VAR_jwt_secret" ]; then
    echo "Error: Required environment variables are not set"
    echo "Please set:"
    echo "  - TF_VAR_db_admin_username"
    echo "  - TF_VAR_db_admin_password"
    echo "  - TF_VAR_jwt_secret"
    exit 1
fi

# Initialize Terraform
echo "Initializing Terraform..."
terraform init

# Validate Terraform configuration
echo "Validating Terraform configuration..."
terraform validate

# Create Terraform plan
echo "Creating Terraform plan..."
terraform plan -out=tfplan

# Ask for confirmation before applying
read -p "Do you want to apply this plan? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    # Apply Terraform plan
    echo "Applying Terraform plan..."
    terraform apply tfplan

    # Clean up plan file
    rm tfplan

    echo "Deployment complete!"
    
    # Output important information
    echo "Important Information:"
    echo "====================="
    echo "API URL: $(terraform output -raw api_url)"
    echo "Frontend URL: $(terraform output -raw frontend_url)"
    echo "Database Server: $(terraform output -raw db_server)"
else
    echo "Deployment cancelled"
    rm tfplan
    exit 0
fi 
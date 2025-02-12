#!/bin/bash

# Exit on error
set -e

# Check if AWS credentials are set
if [ -z "$AWS_ACCESS_KEY_ID" ] || [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
    echo "Error: AWS credentials are not set"
    echo "Please set AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY environment variables"
    exit 1
fi

# Check if required environment variables are set
if [ -z "$TF_VAR_db_username" ] || [ -z "$TF_VAR_db_password" ]; then
    echo "Error: Database credentials are not set"
    echo "Please set TF_VAR_db_username and TF_VAR_db_password environment variables"
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
    echo "RDS Endpoint: $(terraform output -raw rds_endpoint)"
    echo "ALB DNS Name: $(terraform output -raw alb_dns_name)"
    echo "ECR Repository URL: $(terraform output -raw ecr_repository_url)"
else
    echo "Deployment cancelled"
    rm tfplan
    exit 0
fi 
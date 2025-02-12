/**
 * @file main.tf
 * @description Main Terraform configuration for Irrigation Monitoring System
 * @author [Your Company Name]
 * @version 1.0.0
 * @lastModified 2024-03-21
 */

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

# Random string for unique names
resource "random_string" "storage_account_suffix" {
  length  = 8
  special = false
  upper   = false
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "${var.project_name}-${var.environment}-rg"
  location = var.location

  tags = var.common_tags
} 
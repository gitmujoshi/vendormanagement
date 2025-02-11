/**
 * @file variables.tf
 * @description Variable definitions for Terraform configuration
 */

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "irrigation"
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastus"
}

variable "db_admin_username" {
  description = "Database administrator username"
  type        = string
}

variable "db_admin_password" {
  description = "Database administrator password"
  type        = string
  sensitive   = true
}

variable "jwt_secret" {
  description = "Secret key for JWT tokens"
  type        = string
  sensitive   = true
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = {
    Project     = "Irrigation Monitoring"
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
} 
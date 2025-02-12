/**
 * @file variables.tf
 * @description Variables for Azure infrastructure with enhanced security and monitoring
 */

variable "project_name" {
  description = "Name of the project"
  type        = string
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
  sensitive   = true
}

variable "db_admin_password" {
  description = "Database administrator password"
  type        = string
  sensitive   = true
}

variable "azure_ad_admin_username" {
  description = "Azure AD administrator username"
  type        = string
}

variable "azure_ad_admin_object_id" {
  description = "Azure AD administrator object ID"
  type        = string
}

variable "allowed_ip_addresses" {
  description = "List of IP addresses allowed to access the database"
  type        = list(string)
  default     = []
}

variable "security_alert_emails" {
  description = "List of email addresses for security alerts"
  type        = list(string)
  default     = []
}

variable "private_endpoint_subnet_id" {
  description = "Subnet ID for private endpoint"
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics Workspace ID for diagnostic settings"
  type        = string
}

variable "key_vault_object_ids" {
  description = "List of object IDs that need access to Key Vault"
  type        = list(string)
  default     = []
}

variable "sql_server_version" {
  description = "SQL Server version"
  type        = string
  default     = "12.0"
}

variable "sql_database_sku" {
  description = "SQL Database SKU"
  type = object({
    production = string
    development = string
  })
  default = {
    production  = "S1"
    development = "S0"
  }
}

variable "backup_retention_days" {
  description = "Backup retention days"
  type = object({
    production = number
    development = number
  })
  default = {
    production  = 35
    development = 7
  }
}

variable "common_tags" {
  description = "Common tags to be applied to all resources"
  type        = map(string)
  default     = {}
} 
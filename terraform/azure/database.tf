/**
 * @file database.tf
 * @description Azure SQL Database configuration with enhanced security and performance
 */

resource "azurerm_sql_server" "main" {
  name                         = "${var.project_name}-${var.environment}-sql"
  resource_group_name          = azurerm_resource_group.main.name
  location                     = azurerm_resource_group.main.location
  version                      = "12.0"
  administrator_login          = var.db_admin_username
  administrator_login_password = var.db_admin_password

  # Enable Azure AD authentication
  azuread_administrator {
    login_username = var.azure_ad_admin_username
    object_id     = var.azure_ad_admin_object_id
  }

  # Enable encryption
  identity {
    type = "SystemAssigned"
  }

  tags = var.common_tags
}

resource "azurerm_sql_database" "main" {
  name                = "${var.project_name}-${var.environment}-db"
  resource_group_name = azurerm_resource_group.main.name
  location           = azurerm_resource_group.main.location
  server_name        = azurerm_sql_server.main.name
  
  # Enhanced performance settings
  edition                          = "Standard"
  requested_service_objective_name = var.environment == "production" ? "S1" : "S0"

  # Backup settings
  zone_redundant           = var.environment == "production"
  geo_backup_enabled       = var.environment == "production"
  backup_retention_days    = var.environment == "production" ? 35 : 7

  # Enable advanced threat protection
  threat_detection_policy {
    state                      = "Enabled"
    email_account_admins      = true
    email_addresses           = var.security_alert_emails
    retention_days            = 30
    disabled_alerts           = []
    storage_account_access_key = azurerm_storage_account.audit.primary_access_key
    storage_endpoint          = azurerm_storage_account.audit.primary_blob_endpoint
  }
  
  tags = var.common_tags
}

# Storage account for audit logs
resource "azurerm_storage_account" "audit" {
  name                     = "${lower(var.project_name)}${var.environment}audit"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version         = "TLS1_2"

  tags = var.common_tags
}

# Firewall rules
resource "azurerm_sql_firewall_rule" "allow_azure_services" {
  name                = "AllowAzureServices"
  resource_group_name = azurerm_resource_group.main.name
  server_name         = azurerm_sql_server.main.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

# Add development IPs if specified
resource "azurerm_sql_firewall_rule" "dev_ips" {
  count               = length(var.allowed_ip_addresses)
  name                = "DevIP-${count.index}"
  resource_group_name = azurerm_resource_group.main.name
  server_name         = azurerm_sql_server.main.name
  start_ip_address    = var.allowed_ip_addresses[count.index]
  end_ip_address      = var.allowed_ip_addresses[count.index]
}

# Enable auditing
resource "azurerm_mssql_server_security_alert_policy" "main" {
  resource_group_name = azurerm_resource_group.main.name
  server_name         = azurerm_sql_server.main.name
  state              = "Enabled"
  email_account_admins = true
  email_addresses     = var.security_alert_emails
}

resource "azurerm_mssql_server_vulnerability_assessment" "main" {
  server_security_alert_policy_id = azurerm_mssql_server_security_alert_policy.main.id
  storage_container_path         = "${azurerm_storage_account.audit.primary_blob_endpoint}vulnerability-assessment"
  storage_account_access_key    = azurerm_storage_account.audit.primary_access_key
  recurring_scans {
    enabled                   = true
    email_subscription_admins = true
    emails                   = var.security_alert_emails
  }
} 
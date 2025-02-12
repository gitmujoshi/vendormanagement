resource "azurerm_sql_server" "main" {
  name                         = "${var.project_name}-${var.environment}-sql"
  resource_group_name          = azurerm_resource_group.main.name
  location                     = azurerm_resource_group.main.location
  version                      = "12.0"
  administrator_login          = var.db_admin_username
  administrator_login_password = var.db_admin_password

  tags = var.common_tags
}

resource "azurerm_sql_database" "main" {
  name                = "${var.project_name}-${var.environment}-db"
  resource_group_name = azurerm_resource_group.main.name
  location           = azurerm_resource_group.main.location
  server_name        = azurerm_sql_server.main.name
  edition            = "Standard"
  
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
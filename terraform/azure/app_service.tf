resource "azurerm_app_service_plan" "main" {
  name                = "${var.project_name}-${var.environment}-plan"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Standard"
    size = "S1"
  }

  tags = var.common_tags
}

resource "azurerm_app_service" "api" {
  name                = "${var.project_name}-${var.environment}-api"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  app_service_plan_id = azurerm_app_service_plan.main.id

  site_config {
    linux_fx_version = "NODE|14-lts"
    always_on        = true
  }

  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
    "WEBSITE_NODE_DEFAULT_VERSION"        = "~14"
    "NODE_ENV"                           = var.environment
    "DB_HOST"                           = azurerm_sql_server.main.fully_qualified_domain_name
    "DB_NAME"                           = azurerm_sql_database.main.name
    "DB_USER"                           = var.db_admin_username
    "DB_PASSWORD"                       = var.db_admin_password
    "JWT_SECRET"                        = var.jwt_secret
  }

  tags = var.common_tags
}

resource "azurerm_app_service" "frontend" {
  name                = "${var.project_name}-${var.environment}-frontend"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  app_service_plan_id = azurerm_app_service_plan.main.id

  site_config {
    linux_fx_version = "NODE|14-lts"
    always_on        = true
  }

  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
    "WEBSITE_NODE_DEFAULT_VERSION"        = "~14"
    "NODE_ENV"                           = var.environment
    "REACT_APP_API_URL"                  = "https://${azurerm_app_service.api.default_site_hostname}"
  }

  tags = var.common_tags
} 
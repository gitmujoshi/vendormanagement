/**
 * @file app_service.tf
 * @description Azure App Service configuration for backend API
 */

resource "azurerm_app_service_plan" "main" {
  name                = "${var.project_name}-${var.environment}-asp"
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
    linux_fx_version = "NODE|18-lts"
    always_on        = true
  }

  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
    "WEBSITE_NODE_DEFAULT_VERSION"        = "~18"
    "WEBSITE_RUN_FROM_PACKAGE"           = "1"
    "DATABASE_URL"                       = "Server=tcp:${azurerm_sql_server.main.fully_qualified_domain_name},1433;Database=${azurerm_sql_database.main.name};User ID=${var.db_admin_username};Password=${var.db_admin_password};Encrypt=true"
    "JWT_SECRET"                         = var.jwt_secret
    "NODE_ENV"                          = var.environment
  }

  tags = var.common_tags
} 
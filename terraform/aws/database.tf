/**
 * @file database.tf
 * @description Azure SQL Database configuration
 */

resource "azurerm_sql_server" "main" {
  name                         = "${var.project_name}-${var.environment}-sql"
  resource_group_name         = azurerm_resource_group.main.name
  location                    = azurerm_resource_group.main.location
  version                     = "12.0"
  administrator_login         = var.db_admin_username
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

resource "aws_db_subnet_group" "main" {
  name       = "${var.environment}-irrigation-db-subnet"
  subnet_ids = module.vpc.private_subnets

  tags = {
    Name = "${var.environment}-irrigation-db-subnet"
  }
}

resource "aws_security_group" "rds" {
  name        = "${var.environment}-irrigation-rds-sg"
  description = "Security group for RDS instance"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_tasks.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-irrigation-rds-sg"
  }
}

resource "aws_db_instance" "postgres" {
  identifier        = "${var.environment}-irrigation-db"
  engine            = "postgres"
  engine_version    = "14"
  instance_class    = var.db_instance_class
  allocated_storage = var.db_allocated_storage

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  backup_retention_period = 7
  backup_window          = "03:00-04:00"
  maintenance_window     = "Mon:04:00-Mon:05:00"

  multi_az               = var.environment == "production"
  skip_final_snapshot    = true
  
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  
  parameter_group_name = aws_db_parameter_group.postgres.name

  tags = {
    Name = "${var.environment}-irrigation-db"
  }
}

resource "aws_db_parameter_group" "postgres" {
  family = "postgres14"
  name   = "${var.environment}-irrigation-db-params"

  parameter {
    name  = "log_connections"
    value = "1"
  }

  parameter {
    name  = "log_disconnections"
    value = "1"
  }

  parameter {
    name  = "log_checkpoints"
    value = "1"
  }
}

# Variables
variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "Allocated storage for RDS instance in GB"
  type        = number
  default     = 20
}

variable "db_name" {
  description = "Name of the database"
  type        = string
  default     = "irrigation_db"
}

variable "db_username" {
  description = "Database master username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Database master password"
  type        = string
  sensitive   = true
} 
/**
 * @file database.tf
 * @description AWS RDS Database configuration with encryption and enhanced security
 */

resource "aws_db_subnet_group" "main" {
  name       = "${var.environment}-irrigation-db-subnet"
  subnet_ids = module.vpc.private_subnets

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-irrigation-db-subnet"
    }
  )
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

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-irrigation-rds-sg"
    }
  )
}

# KMS key for RDS encryption
resource "aws_kms_key" "rds" {
  description             = "KMS key for RDS encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-irrigation-rds-key"
    }
  )
}

resource "aws_db_instance" "postgres" {
  identifier        = "${var.environment}-irrigation-db"
  engine            = "postgres"
  engine_version    = var.db_engine_version
  instance_class    = var.db_instance_class
  allocated_storage = var.db_allocated_storage

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  # Enhanced backup settings
  backup_retention_period = var.environment == "production" ? 35 : 7
  backup_window          = "03:00-04:00"
  maintenance_window     = "Mon:04:00-Mon:05:00"
  copy_tags_to_snapshot  = true

  # High availability settings
  multi_az               = var.environment == "production"
  skip_final_snapshot    = false
  final_snapshot_identifier = "${var.environment}-irrigation-db-final-snapshot"
  
  # Encryption settings
  storage_encrypted      = true
  kms_key_id            = aws_kms_key.rds.arn
  
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  
  parameter_group_name = aws_db_parameter_group.postgres.name

  # Monitoring configurations
  monitoring_interval = 60
  monitoring_role_arn = aws_iam_role.rds_monitoring_role.arn

  # Storage autoscaling
  max_allocated_storage = var.db_max_allocated_storage

  # Performance insights
  performance_insights_enabled = true
  performance_insights_retention_period = var.environment == "production" ? 731 : 7
  performance_insights_kms_key_id = aws_kms_key.rds.arn

  # Auto minor version upgrade
  auto_minor_version_upgrade = true

  # Enhanced monitoring
  monitoring_interval = 60
  monitoring_role_arn = aws_iam_role.rds_monitoring_role.arn

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-irrigation-db"
    }
  )
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

  parameter {
    name  = "shared_preload_libraries"
    value = "pg_stat_statements,auto_explain"
  }

  parameter {
    name  = "auto_explain.log_min_duration"
    value = "5000"
  }

  parameter {
    name  = "log_min_duration_statement"
    value = "5000"
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-irrigation-db-params"
    }
  )
}

# RDS Enhanced Monitoring IAM Role
resource "aws_iam_role" "rds_monitoring_role" {
  name = "${var.environment}-rds-monitoring-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "monitoring.rds.amazonaws.com"
        }
      }
    ]
  })

  tags = var.common_tags
}

resource "aws_iam_role_policy_attachment" "rds_monitoring_policy" {
  role       = aws_iam_role.rds_monitoring_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
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

variable "db_max_allocated_storage" {
  description = "Maximum allocated storage for RDS instance in GB"
  type        = number
  default     = 100
}

variable "db_engine_version" {
  description = "RDS engine version"
  type        = string
  default     = "14"
} 
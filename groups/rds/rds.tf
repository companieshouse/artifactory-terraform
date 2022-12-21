resource "aws_db_subnet_group" "db_subnet_group" {
  name       = local.db_subnet
  subnet_ids = local.placement_subnet_ids
  tags       = {
    Name        = local.db_subnet
  }
}

resource "aws_db_parameter_group" "db_parameter_group" {
  name        = "${var.environment}-${var.service}-${var.db_engine}-parameter-group"
  family      = "${var.db_engine}${var.db_engine_version}"
  description = "Parameter group for ${var.environment}-${var.service}-${var.db_engine}"
  tags        = {
    Name = "${var.environment}-${var.service}-${var.db_engine}"
    Type = "parameter-group"
  }
}

resource "aws_db_option_group" "db_option_group" {
  name                     = "${var.environment}-${var.service}-${var.db_engine}-option-group"
  option_group_description = "Option group for ${var.environment}-${var.service}-${var.db_engine}"
  engine_name              = var.db_engine
  major_engine_version     = var.db_engine_version
  tags                     = {
    Name = "${var.environment}-${var.service}-${var.db_engine}"
    Type = "option-group"
  }
}

resource "aws_db_instance" "db" {
  allocated_storage               = var.db_storage_gb
  name                            = var.service
  engine                          = var.db_engine
  engine_version                  = var.db_engine_version
  instance_class                  = var.db_instance_class
  username                        = local.db_username
  password                        = local.db_password
  db_subnet_group_name            = aws_db_subnet_group.db_subnet_group.name
  parameter_group_name            = aws_db_parameter_group.db_parameter_group.name
  option_group_name               = aws_db_option_group.db_option_group.name
  storage_type                    = var.db_storage_type
  port                            = var.db_port
  enabled_cloudwatch_logs_exports = var.rds_cloudwatch_logs_exports
  deletion_protection             = var.db_deletion_protection
  backup_retention_period         = var.db_backup_retention_period
  backup_window                   = var.db_backup_window
  maintenance_window              = var.db_maintenance_window
  final_snapshot_identifier       = "${var.environment}-${var.service}-${var.db_engine}-final-deletion-snapshot"
  skip_final_snapshot             = false
  identifier                      = "${var.environment}-${var.service}-${var.db_engine}"
  vpc_security_group_ids          = [aws_security_group.db_security_group.id]
  tags                            = {
    Type = "rds"
  }
}

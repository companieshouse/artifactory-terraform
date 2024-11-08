resource "aws_db_subnet_group" "rds" {
  name       = "${local.resource_prefix}-db-subnet-group"
  subnet_ids = local.placement_subnet_ids

  tags = {
    Name = "${local.resource_prefix}-db-subnet-group"
  }
}

resource "aws_db_parameter_group" "db_parameter_group" {
  name        = "${local.resource_prefix}-${var.db_engine}-parameter-group"
  family      = "${var.db_engine}${var.db_engine_major_version}"
  description = "Parameter group for ${local.resource_prefix}-${var.db_engine}"

  tags = {
    Name = "${local.resource_prefix}-${var.db_engine}-parameter-group"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_db_option_group" "db_option_group" {
  name                     = "${local.resource_prefix}-${var.db_engine}-option-group"
  option_group_description = "Option group for ${local.resource_prefix}-${var.db_engine}"
  engine_name              = var.db_engine
  major_engine_version     = var.db_engine_major_version

  tags = {
    Name = "${local.resource_prefix}-${var.db_engine}-option-group"
  }
}

resource "aws_db_instance" "db" {
  identifier           = "${local.resource_prefix}-${var.db_engine}"
  db_name              = var.service
  engine               = var.db_engine
  engine_version       = var.db_engine_major_version
  instance_class       = var.db_instance_class
  username             = local.db_username
  password             = local.db_password
  port                 = var.db_port
  parameter_group_name = aws_db_parameter_group.db_parameter_group.name
  option_group_name    = aws_db_option_group.db_option_group.name
  multi_az             = var.db_instance_multi_az
  deletion_protection  = var.db_deletion_protection

  allocated_storage  = var.db_storage_gb
  iops               = local.db_storage_iops
  kms_key_id         = data.aws_kms_alias.rds.target_key_arn
  storage_encrypted  = true
  storage_throughput = local.db_storage_throughput
  storage_type       = var.db_storage_type

  enabled_cloudwatch_logs_exports = var.rds_cloudwatch_logs_exports
  backup_retention_period         = var.db_backup_retention_period
  backup_window                   = var.db_backup_window
  maintenance_window              = var.db_maintenance_window
  final_snapshot_identifier       = "${var.environment}-${var.service}-${var.db_engine}-final-deletion-snapshot"
  skip_final_snapshot             = false

  db_subnet_group_name   = aws_db_subnet_group.rds.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  tags = {
    Name = "${local.resource_prefix}-${var.db_engine}"
  }
}

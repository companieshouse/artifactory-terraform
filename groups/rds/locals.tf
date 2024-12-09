locals {
  account_ids = data.vault_generic_secret.account_ids.data
  secrets     = data.vault_generic_secret.secrets.data

  resource_prefix = "${var.environment}-${var.service}"

  placement_subnet_cidrs = values(zipmap(
    values(data.aws_subnet.placement).*.availability_zone,
    values(data.aws_subnet.placement).*.cidr_block
  ))
  placement_subnet_ids = values(zipmap(
    values(data.aws_subnet.placement).*.availability_zone,
    values(data.aws_subnet.placement).*.id
  ))
  placement_subnet_pattern = local.secrets.placement_subnet_pattern
  placement_vpc_pattern    = local.secrets.placement_vpc_pattern

  current_account_id = data.aws_caller_identity.current.account_id

  dns_zone_name = local.secrets.dns_zone_name

  db_username = local.secrets.db_username
  db_password = local.secrets.db_password

  db_storage_threshold = 400
  db_storage_map = {
    small = {
      iops       = null
      throughput = null
    },
    large = {
      iops       = 12000
      throughput = 500
    }
  }

  db_storage_iops       = var.db_storage_gb < local.db_storage_threshold ? local.db_storage_map.small.iops : local.db_storage_map.large.iops
  db_storage_throughput = var.db_storage_gb < local.db_storage_threshold ? local.db_storage_map.small.throughput : local.db_storage_map.large.throughput

  rds_cloudwatch_logs_arn_prefix = "arn:aws:logs:${var.region}:${local.current_account_id}"
}

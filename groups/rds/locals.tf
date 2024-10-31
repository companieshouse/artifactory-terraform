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

  dns_zone_name            = local.secrets.dns_zone_name

  db_username              = local.secrets.db_username
  db_password              = local.secrets.db_password

  db_storage_threshold = 400
  db_storage_map       = {
    gp2 = {
      small = {
        iops       = null
        throughput = null
      },
      large = {
        iops       = null
        throughput = null
      }
    },
    gp3 = {
      small = {
        iops       = 3000
        throughput = null
      },
      large = {
        iops       = 12000
        throughput = 500
      }
    }
  }

  db_storage_iops       = var.db_storage_gb < local.db_storage_threshold ? local.db_storage_map[var.db_storage_type].small.iops : local.db_storage_map[var.db_storage_type].large.iops
  db_storage_throughput = var.db_storage_gb < local.db_storage_threshold ? local.db_storage_map[var.db_storage_type].small.throughput : local.db_storage_map[var.db_storage_type].large.throughput
}

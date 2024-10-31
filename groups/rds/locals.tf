locals {
  account_ids = data.vault_generic_secret.account_ids.data
  secrets     = data.vault_generic_secret.secrets.data

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
  dns_zone_is_private      = local.secrets.dns_zone_is_private

  db_subnet                = local.secrets.db_subnet
  db_username              = local.secrets.db_username
  db_password              = local.secrets.db_password
}

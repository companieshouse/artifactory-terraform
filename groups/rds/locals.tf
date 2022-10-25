locals {
  account_ids = data.vault_generic_secret.account_ids.data

  placement_subnet_cidrs = values(zipmap(
    values(data.aws_subnet.placement).*.availability_zone,
    values(data.aws_subnet.placement).*.cidr_block
  ))

  placement_subnet_ids = values(zipmap(
    values(data.aws_subnet.placement).*.availability_zone,
    values(data.aws_subnet.placement).*.id
  ))

  secrets = data.vault_generic_secret.secrets.data
  placement_subnet_pattern = local.secrets.placement_subnet_pattern

  certificate_arn = lookup(local.secrets, "certificate_arn", null)
  dns_zone_name = local.secrets.dns_zone_name
  load_balancer_dns_zone_name = local.secrets.load_balancer_dns_zone_name
  placement_subnet_name_patterns = jsondecode(local.secrets.placement_subnet_name_patterns)
  placement_vpc_pattern = local.secrets.placement_vpc_pattern

}
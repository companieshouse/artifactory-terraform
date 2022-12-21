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

  automation_subnet_cidrs = values(zipmap(
    values(data.aws_subnet.automation).*.availability_zone,
    values(data.aws_subnet.automation).*.cidr_block
  ))
  automation_subnet_ids = values(zipmap(
    values(data.aws_subnet.automation).*.availability_zone,
    values(data.aws_subnet.automation).*.id
  ))
  automation_subnet_pattern   = local.secrets.automation_subnet_pattern
  automation_vpc_pattern      = local.secrets.automation_vpc_pattern


  certificate_arn             = lookup(local.secrets, "certificate_arn", null)
  dns_zone_name               = local.secrets.dns_zone_name
  load_balancer_dns_zone_name = local.secrets.load_balancer_dns_zone_name

  db_subnet                   = local.secrets.db_subnet
  db_username                 = local.secrets.db_username
  db_password                 = local.secrets.db_password
  db_port                     = var.db_port
  db_cidrs                    = concat(
    local.placement_subnet_cidrs,
    local.automation_subnet_cidrs
  )

}

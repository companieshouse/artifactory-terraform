data "vault_generic_secret" "account_ids" {
  path = "aws-accounts/account-ids"
}

data "vault_generic_secret" "secrets" {
  path = "team-${var.team}/${var.account_name}/${var.region}/${var.environment}/${var.repository_name}"
}

data "aws_vpc" "placement" {
  filter {
    name   = "tag:Name"
    values = [local.placement_vpc_pattern]
  }
}

data "aws_subnet" "placement" {
  for_each = data.aws_subnet_ids.placement.ids
  id       = each.value
}

data "aws_subnet_ids" "placement" {
  vpc_id = data.aws_vpc.placement.id

  filter {
    name   = "tag:Name"
    values = [local.placement_subnet_pattern]
  }
}

data "aws_route53_zone" "selected" {
  name         = local.dns_zone_name
  private_zone = local.dns_zone_is_private
}

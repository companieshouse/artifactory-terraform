data "vault_generic_secret" "account_ids" {
  path = "aws-accounts/account-ids"
}

data "vault_generic_secret" "secrets" {
  path = "team-${var.team}/${var.account_name}/${var.region}/${var.environment}/${var.service}"
}

data "aws_vpc" "placement" {
  filter {
    name   = "tag:Name"
    values = [local.placement_vpc_pattern]
  }
}

data "aws_subnet" "placement" {
  for_each = toset(data.aws_subnets.placement.ids)

  id = each.value
}

data "aws_subnets" "placement" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.placement.id]
  }

  filter {
    name   = "tag:Name"
    values = [local.placement_subnet_pattern]
  }
}

data "aws_route53_zone" "selected" {
  name         = local.dns_zone_name
  private_zone = var.dns_zone_is_private
}

data "aws_kms_alias" "rds" {
  name = var.rds_kms_key_alias
}

data "aws_caller_identity" "current" {}

data "vault_generic_secret" "account_ids" {
  path = "aws-accounts/account-ids"
}

data "vault_generic_secret" "secrets" {
  path = "team-${var.team}/${var.secrets_account_name}/${var.region}/${var.secrets_environment}/${var.repository_name}"
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
  private_zone = true

  #vpc {
    #vpc_id = data.aws_vpc.placement.id
  #}
}

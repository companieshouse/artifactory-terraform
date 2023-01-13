data "aws_ec2_managed_prefix_list" "administration" {
  filter {
    name   = "prefix-list-name"
    values = ["administration-cidr-ranges"]
  }
}

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

data "aws_vpc" "automation" {
  filter {
    name   = "tag:Name"
    values = [local.automation_vpc_pattern]
  }
}

data "aws_subnet" "automation" {
  for_each = data.aws_subnet_ids.automation.ids
  id = each.value
}

data "aws_subnet_ids" "automation" {
  vpc_id = data.aws_vpc.automation.id

  filter {
    name   = "tag:Name"
    values = [local.automation_subnet_pattern]
  }
}


data "aws_route53_zone" "selected" {
  name         = local.dns_zone_name
  private_zone = false
}

data "aws_ami" "artifactory_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["artifactory-*"]
  }
  owners = split(", ", local.artifactory_account_ids)
}

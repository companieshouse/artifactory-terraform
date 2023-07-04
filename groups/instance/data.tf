data "aws_ec2_managed_prefix_list" "administration" {
  filter {
    name   = "prefix-list-name"
    values = ["administration-cidr-ranges"]
  }
}

# data "vault_generic_secret" "account_ids" {
#   path = "aws-accounts/account-ids"
# }

data "vault_generic_secret" "secrets" {
  path = "team-${var.team}/${var.account_name}/${var.region}/${var.environment}/${var.service}"
}

data "vault_generic_secret" "security_kms_keys" {
  count = var.enable_ssm_access ? 1 : 0
  path  = "aws-accounts/security/kms"
}

data "aws_caller_identity" "current" {}

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
  id       = each.value
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
  private_zone = local.dns_zone_isprivate
}

data "aws_ami" "artifactory_ami" {
  most_recent = true
  owners      = [local.ami_owner_id]
  name_regex  = "${var.service}-${var.default_ami_version_pattern}"

  filter {
    name   = "name"
    values = ["${var.service}-*"]
  }
}

data "aws_acm_certificate" "certificate" {
  count       = local.create_ssl_certificate ? 0 : 1
  domain      = var.ssl_certificate_name
  statuses    = ["ISSUED"]
  most_recent = true
}


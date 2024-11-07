data "aws_ec2_managed_prefix_list" "administration" {
  name = "administration-cidr-ranges"
}

data "aws_ec2_managed_prefix_list" "concourse" {
  name = "shared-services-management-cidrs"
}

data "vault_generic_secret" "secrets" {
  path = "team-${var.team}/${var.account_name}/${var.region}/${var.environment}/${var.service}"
}

data "vault_generic_secret" "security_kms_keys" {
  path = "aws-accounts/security/kms"
}

data "vault_generic_secret" "security_s3_buckets" {
  path = "aws-accounts/security/s3"
}

data "vault_generic_secret" "security_efs_kms_keys_data" {
  path = "aws-accounts/${var.account_name}/kms"
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
  for_each = toset(data.aws_subnets.automation.ids)

  id = each.value
}

data "aws_subnet" "placement" {
  for_each = toset(data.aws_subnets.placement.ids)

  id = each.value
}

data "aws_subnets" "automation" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.automation.id]
  }

  filter {
    name   = "tag:Name"
    values = [local.automation_subnet_pattern]
  }
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
  count = local.create_ssl_certificate ? 0 : 1

  domain      = local.ssl_certificate_name
  statuses    = ["ISSUED"]
  most_recent = true
}

data "aws_iam_role" "asg" {
  name = "AWSServiceRoleForAutoScaling"
}

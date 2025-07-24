terraform {
  required_version = ">= 1.3.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0, < 6.0"
    }
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = ">= 2.3.0, < 3.0.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = ">= 4.0, < 5.0"
    }
  }
  backend "s3" {}
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Environment = var.environment
      Team        = var.team
      Service     = var.service
    }
  }
}

provider "aws" {
  alias  = "heritage_development_euw2"
  region = "eu-west-2"

  assume_role {
    role_arn = "arn:aws:iam::${local.account_ids["heritage-development"]}:role/${data.aws_caller_identity.current.account_id}-terraform-lookup"
  }
}

module "efs_file_system" {
  source                    = "git@github.com:companieshouse/terraform-modules//aws/efs?ref=1.0.338"
  environment               = var.environment
  service                   = var.service
  permit_client_root_access = var.efs_permit_client_root_access
  vpc_id                    = data.aws_vpc.placement.id
  subnet_ids                = data.aws_subnets.placement.ids
  kms_key_arn               = aws_kms_key.artifactory.arn
  throughput_mode           = "elastic"
  performance_mode          = "generalPurpose"

  access_points = {
    "${var.efs_artifacts_access_point_name}" = {
      permissions    = "0755"
      posix_user_gid = 992
      posix_user_uid = 992
      root_directory = "/${var.efs_artifacts_access_point_name}"
    }
  }
}

module "heritage_dev_euw2_app_subnets" {
  source = "git@github.com:companieshouse/terraform-modules//aws/subnet-lookup?ref=1.0.338"

  providers = {
    aws = aws.heritage_development_euw2
  }

  subnet_pattern = local.heritage_development_app_subnet_pattern
  vpc_pattern    = local.heritage_development_vpc_pattern
}

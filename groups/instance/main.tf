terraform {
  required_version = ">= 0.13.0, < 0.14"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0, < 4.0"
    }
    artifactory = {
      source = "jfrog/artifactory"
      #source  = "registry.terraform.io/jfrog/artifactory"
      version = "7.4.3"
    }
  }

  #backend "s3" {}
}

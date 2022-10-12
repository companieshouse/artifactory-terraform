provider "aws" {
  region = var.region
  alias   = "development_${var.region}"
  assume_role {
    role_arn = "arn:aws:iam::${local.account_ids.development}:role/terraform-lookup"
  }
}
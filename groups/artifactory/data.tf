data "aws_ec2_managed_prefix_list" "administration" {
  name         = "administration-cidr-ranges"
}

data "vault_generic_secret" "secrets" {
  path         = "team-${var.team}/${var.account_name}/${var.region}/${var.environment}/${var.repository_name}"
}

data "aws_route53_zone" "selected" {
  name         = local.dns_zone_name
  private_zone = false
}

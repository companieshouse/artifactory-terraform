locals {
  secrets                                     = data.vault_generic_secret.secrets.data
  artifactory_access_token                    = local.secrets.artifactory_access_token
  server_url                                  = "${var.service}.${var.environment}.${data.aws_route53_zone.selected.name}:8081/artifactory"
  #server_url                                  = "http://${var.service}.${var.environment}.${local.secrets.dns_zone_name}:8081/artifactory"
}

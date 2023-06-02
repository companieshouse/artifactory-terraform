locals {
  secrets                                     = data.vault_generic_secret.secrets.data
  artifactory_access_token                    = local.secrets.artifactory_access_token
  server_url                                  = "http://${var.service}.${var.environment}.${local.secrets.dns_zone_name}:8081/artifactory"
}

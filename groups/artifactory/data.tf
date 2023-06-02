data "vault_generic_secret" "secrets" {
  path         = "team-${var.team}/${var.account_name}/${var.region}/${var.environment}/${var.repository_name}"
}


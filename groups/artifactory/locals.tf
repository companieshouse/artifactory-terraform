locals {
  secrets     = data.vault_generic_secret.secrets.data
  artifactory_access_token                                 = local.secrets.artifactory_access_token
  server_url = "${var.service}.${var.environment}.${data.aws_route53_zone.selected.name}:8081/artifactory"

  ldapSetting_id                                           = "ldap1"
  ldapSetting_emailAttribute                               = local.secrets.ldapSetting_emailAttribute
  ldapSetting_ldapUrl                                      = local.secrets.ldapSetting_ldapUrl
  ldapSetting_managerDn                                    = local.secrets.ldapSetting_managerDn
  ldapSetting_managerPassword                              = local.secrets.ldapSetting_managerPassword
  ldapSetting_searchBase                                   = local.secrets.ldapSetting_searchBase
  ldapSetting_searchFilter                                 = local.secrets.ldapSetting_searchFilter
  ldapSetting_searchSubTree                                = local.secrets.ldapSetting_searchSubTree
  ldapSetting_userDnPattern                                = local.secrets.ldapSetting_userDnPattern
  ldapSetting_allowUserToAccessProfile                     = local.secrets.ldapSetting_allowUserToAccessProfile
  ldapSetting_descriptionAttribute                         = local.secrets.ldapSetting_descriptionAttribute
  ldapGroupSettings_descriptionAttribute                   = local.secrets.ldapGroupSettings_descriptionAttribute
  ldapGroupSettings_enabledLdap                            = local.ldapSetting_id
  ldapGroupSettings_filter                                 = local.secrets.ldapGroupSettings_filter
  ldapGroupSettings_groupBaseDn                            = local.secrets.ldapGroupSettings_groupBaseDn
  ldapGroupSettings_groupMemberAttribute                   = local.secrets.ldapGroupSettings_groupMemberAttribute
  ldapGroupSettings_groupNameAttribute                     = local.secrets.ldapGroupSettings_groupNameAttribute
  ldapGroupSettings_strategy                               = local.secrets.ldapGroupSettings_strategy
  ldapGroupSettings_subTree                                = local.secrets.ldapGroupSettings_subTree


}

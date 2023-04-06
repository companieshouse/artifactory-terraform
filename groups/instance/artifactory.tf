resource "artifactory_ldap_setting" "ldap_name" {
  depends_on                    = [aws_instance.artifactory]
  key                           = local.ldapSetting_id
  enabled                       = true
  ldap_url                      = local.ldapSetting_ldapUrl
  user_dn_pattern               = local.ldapSetting_userDnPattern
  email_attribute               = local.ldapSetting_emailAttribute
  auto_create_user              = true
  ldap_poisoning_protection     = true
  allow_user_to_access_profile  = local.ldapSetting_allowUserToAccessProfile
  paging_support_enabled        = false
  search_filter                 = local.ldapSetting_searchFilter
  search_base                   = local.ldapSetting_searchBase
  search_sub_tree               = true
  manager_dn                    = local.ldapSetting_managerDn
  manager_password              = local.ldapSetting_managerPassword
}

resource "artifactory_ldap_group_setting" "ldap_group_name" {
  depends_on             = [aws_instance.artifactory]
  name                   = local.ldapGroupSettings_groupNameAttribute
  enabled_ldap           = local.ldapGroupSettings_enabledLdap
  group_base_dn          = local.ldapGroupSettings_groupBaseDn
  group_name_attribute   = local.ldapGroupSettings_groupNameAttribute
  group_member_attribute = local.ldapGroupSettings_groupMemberAttribute
  sub_tree               = local.ldapGroupSettings_subTree
  filter                 = local.ldapGroupSettings_filter
  description_attribute  = local.ldapGroupSettings_descriptionAttribute
  strategy               = local.ldapGroupSettings_strategy
}

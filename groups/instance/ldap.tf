resource "artifactory_ldap_setting" "ldap" {
  key                          = local.ldap_setting_key
  enabled                      = true
  ldap_url                     = local.ldap_setting_ldap_url
  user_dn_pattern              = local.ldap_setting_user_dn_pattern
  email_attribute              = local.ldap_setting_email_attribute
  auto_create_user             = true
  ldap_poisoning_protection    = true
  allow_user_to_access_profile = local.ldap_setting_allow_user_to_access_profile
  paging_support_enabled       = false
  search_filter                = local.ldap_setting_search_filter
  search_base                  = local.ldap_setting_search_base
  search_sub_tree              = local.ldap_setting_search_subtree
  manager_dn                   = local.ldap_setting_managerdn
  manager_password             = local.ldap_setting_manager_password
}

resource "artifactory_ldap_group_setting" "ldap_group" {
  name                   = local.ldap_group_settings_enabled_ldap
  group_base_dn          = local.ldap_group_settings_group_basedn
  group_name_attribute   = local.ldap_group_settings_group_name_attribute
  group_member_attribute = local.ldap_group_settings_group_member_attribute
  sub_tree               = local.ldap_group_settings_subtree
  filter                 = local.ldap_group_settings_filter
  description_attribute  = local.ldap_group_settings_description_attribute
  strategy               = local.ldap_group_settings_strategy
  ldap_setting_key       = artifactory_ldap_setting.ldap.key
}

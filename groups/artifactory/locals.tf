locals {
  secrets                                     = data.vault_generic_secret.secrets.data
  artifactory_access_token                    = local.secrets.artifactory_access_token
  server_url                                  = "http://${var.service}.${var.environment}.${local.secrets.dns_zone_name}:8081/artifactory"
  
  ldap_setting_key                            = "ldap1"
  ldap_setting_email_attribute                = local.secrets.ldap_setting_email_attribute 
  ldap_setting_ldap_url                       = local.secrets.ldap_setting_ldap_url
  ldap_setting_managerdn                      = local.secrets.ldap_setting_managerdn
  ldap_setting_manager_password               = local.secrets.ldap_setting_manager_password
  ldap_setting_search_base                    = local.secrets.ldap_setting_search_base
  ldap_setting_search_filter                  = local.secrets.ldap_setting_search_filter
  ldap_setting_search_subtree                 = local.secrets.ldap_setting_search_subtree
  ldap_setting_user_dn_pattern                = local.secrets.ldap_setting_user_dn_pattern
  ldap_setting_allow_user_to_access_profile   = local.secrets.ldap_setting_allow_user_to_access_profile
  ldap_group_settings_description_attribute   = local.secrets.ldap_group_settings_description_attribute
  ldap_group_settings_enabled_ldap            = local.ldap_setting_key
  ldap_group_settings_filter                  = local.secrets.ldap_group_settings_filter
  ldap_group_settings_group_basedn            = local.secrets.ldap_group_settings_group_basedn
  ldap_group_settings_group_member_attribute  = local.secrets.ldap_group_settings_group_member_attribute
  ldap_group_settings_group_name_attribute    = local.secrets.ldap_group_settings_group_name_attribute
  ldap_group_settings_strategy                = local.secrets.ldap_group_settings_strategy
  ldap_group_settings_subtree                 = local.secrets.ldap_group_settings_subtree
}

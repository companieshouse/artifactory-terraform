data "cloudinit_config" "artifactory" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = "#cloud-config"
  }

  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/cloud-init/templates/enable_config.tpl", {
      db_fqdn                                    = local.db_fqdn
      db_port                                    = local.db_port
      db_name                                    = var.service
      db_username                                = local.db_username
      db_password                                = local.db_password
      ldap_setting_key                           = local.ldap_setting_key
      ldap_setting_email_attribute               = local.ldap_setting_email_attribute
      ldap_setting_ldap_url                      = local.ldap_setting_ldap_url
      ldap_setting_search_base                   = local.ldap_setting_search_base
      ldap_setting_managerdn                     = local.ldap_setting_managerdn
      ldap_setting_manager_password              = local.ldap_setting_manager_password
      ldap_setting_search_filter                 = local.ldap_setting_search_filter
      ldap_setting_search_subtree                = local.ldap_setting_search_subtree
      ldap_setting_user_dn_pattern               = local.ldap_setting_user_dn_pattern
      ldap_setting_allow_user_to_access_profile  = local.ldap_setting_allow_user_to_access_profile
      ldap_group_settings_description_attribute  = local.ldap_group_settings_description_attribute
      ldap_group_settings_filter                 = local.ldap_group_settings_filter
      ldap_group_settings_group_basedn           = local.ldap_group_settings_group_basedn
      ldap_group_settings_group_member_attribute = local.ldap_group_settings_group_member_attribute
      ldap_group_settings_group_name_attribute   = local.ldap_group_settings_group_name_attribute
      ldap_group_settings_strategy               = local.ldap_group_settings_strategy
      ldap_group_settings_subtree                = local.ldap_group_settings_subtree
      http_proxy_host                            = ""
      http_proxy_port                            = ""
      artifactory_access_token                   = local.artifactory_access_token
      db_fqdn                                    = local.db_fqdn
      db_username                                = local.db_username
      db_password                                = local.db_password
    })
  }

  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/cloud-init/templates/enable_license.tpl", {
      artifactory_license                        = local.artifactory_license
    })
  }

  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/cloud-init/templates/bootstrap-commands.yml.tpl", {
    })
  }
}

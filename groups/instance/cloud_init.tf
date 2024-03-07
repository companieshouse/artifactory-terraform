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
      ldap_setting_key                           = local.ldap_setting_key
      ldap_setting_email_attribute               = local.ldap_setting_email_attribute
      ldap_setting_ldap_url                      = local.ldap_setting_ldap_url
      ldap_setting_search_base                   = local.ldap_setting_search_base
      ldap_setting_search_filter                 = local.ldap_setting_search_filter
      ldap_setting_search_subtree                = local.ldap_setting_search_subtree
      ldap_setting_allow_user_to_access_profile  = local.ldap_setting_allow_user_to_access_profile
      ldap_group_settings_description_attribute  = local.ldap_group_settings_description_attribute
      ldap_group_settings_filter                 = local.ldap_group_settings_filter
      ldap_group_settings_group_basedn           = local.ldap_group_settings_group_basedn
      ldap_group_settings_group_member_attribute = local.ldap_group_settings_group_member_attribute
      ldap_group_settings_group_name_attribute   = local.ldap_group_settings_group_name_attribute
      ldap_group_settings_strategy               = local.ldap_group_settings_strategy
      ldap_group_settings_subtree                = local.ldap_group_settings_subtree
      artifactory_access_token                   = local.artifactory_access_token
      efs_filesystem_id                          = module.efs_file_system.efs_filesystem_id
      efs_access_point_id                        = local.efs_access_point_id
      admin_password_param_name                  = local.admin_password_param_name
      artifactory_license_param_name             = local.artifactory_license_param_name
      db_username_param_name                     = local.db_username_param_name
      db_password_param_name                     = local.db_password_param_name
      db_masterkey_param_name                    = local.db_masterkey_param_name
      ldap_setting_managerdn_param_name          = local.ldap_setting_managerdn_param_name
      ldap_setting_manager_password_param_name   = local.ldap_setting_manager_password_param_name
      aws_command                                = var.aws_command
      region                                     = var.region
      service                                    = var.service
    })
  }
}

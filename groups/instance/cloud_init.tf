data "cloudinit_config" "artifactory" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = "#cloud-config"
  }

  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/cloud-init/templates/test.tpl", {
      db_fqdn                                = local.db_fqdn
      db_port                                = local.db_port
      db_name                                = var.service
      db_username                            = local.db_username
      db_password                            = local.db_password
      ldapSetting_id                         = local.ldapSetting_id
      ldapSetting_emailAttribute             = local.ldapSetting_emailAttribute
      ldapSetting_ldapUrl                    = local.ldapSetting_ldapUrl
      ldapSetting_searchBase                 = local.ldapSetting_searchBase
      ldapSetting_managerDn                  = local.ldapSetting_managerDn
      ldapSetting_managerPassword            = local.ldapSetting_managerPassword
      ldapSetting_searchFilter               = local.ldapSetting_searchFilter
      ldapSetting_searchSubTree              = local.ldapSetting_searchSubTree
      ldapSetting_userDnPattern              = local.ldapSetting_userDnPattern
      ldapSetting_allowUserToAccessProfile   = local.ldapSetting_allowUserToAccessProfile
      ldapSetting_descriptionAttribute       = local.ldapSetting_descriptionAttribute
      ldapGroupSettings_descriptionAttribute = local.ldapGroupSettings_descriptionAttribute
      ldapGroupSettings_filter               = local.ldapGroupSettings_filter
      ldapGroupSettings_groupBaseDn          = local.ldapGroupSettings_groupBaseDn
      ldapGroupSettings_groupMemberAttribute = local.ldapGroupSettings_groupMemberAttribute
      ldapGroupSettings_groupNameAttribute   = local.ldapGroupSettings_groupNameAttribute
      ldapGroupSettings_strategy             = local.ldapGroupSettings_strategy
      ldapGroupSettings_subTree              = local.ldapGroupSettings_subTree
      http_proxy_host                        = ""
      http_proxy_port                        = ""
      artifactory_access_token               = local.artifactory_access_token
    })
   }

  # part {
  #   content_type = "text/cloud-config"
  #   content = templatefile("${path.module}/cloud-init/templates/artifactory.config.import.xml.tpl", {
  #     db_fqdn                                = local.db_fqdn
  #     db_port                                = local.db_port
  #     db_name                                = var.service
  #     db_username                            = local.db_username
  #     db_password                            = local.db_password
  #     ldapSetting_id                         = local.ldapSetting_id
  #     ldapSetting_emailAttribute             = local.ldapSetting_emailAttribute
  #     ldapSetting_ldapUrl                    = local.ldapSetting_ldapUrl
  #     ldapSetting_searchBase                 = local.ldapSetting_searchBase
  #     ldapSetting_managerDn                  = local.ldapSetting_managerDn
  #     ldapSetting_managerPassword            = local.ldapSetting_managerPassword
  #     ldapSetting_searchFilter               = local.ldapSetting_searchFilter
  #     ldapSetting_searchSubTree              = local.ldapSetting_searchSubTree
  #     ldapSetting_userDnPattern              = local.ldapSetting_userDnPattern
  #     ldapSetting_allowUserToAccessProfile   = local.ldapSetting_allowUserToAccessProfile
  #     ldapSetting_descriptionAttribute       = local.ldapSetting_descriptionAttribute
  #     ldapGroupSettings_descriptionAttribute = local.ldapGroupSettings_descriptionAttribute
  #     ldapGroupSettings_filter               = local.ldapGroupSettings_filter
  #     ldapGroupSettings_groupBaseDn          = local.ldapGroupSettings_groupBaseDn
  #     ldapGroupSettings_groupMemberAttribute = local.ldapGroupSettings_groupMemberAttribute
  #     ldapGroupSettings_groupNameAttribute   = local.ldapGroupSettings_groupNameAttribute
  #     ldapGroupSettings_strategy             = local.ldapGroupSettings_strategy
  #     ldapGroupSettings_subTree              = local.ldapGroupSettings_subTree
  #     http_proxy_host                        = ""
  #     http_proxy_port                        = ""
  #     artifactory_access_token               = local.artifactory_access_token
  #   })
  # }

#  part {
#    content_type = "text/cloud-config"
#    content = templatefile("${path.module}/cloud-init/templates/system.yaml.tpl", {
#      db_fqdn                                = local.db_fqdn
#      db_name                                = var.service
#      db_username                            = local.db_username
#      db_password                            = local.db_password
#    })
#  }

  part {
    content_type   = "text/cloud-config"
    content        = templatefile("${path.module}/cloud-init/templates/bootstrap-commands.yml.tpl", {
    })
  }
}

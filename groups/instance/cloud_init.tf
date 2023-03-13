data "cloudinit_config" "artifactory" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = "#cloud-config"
  }

  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/cloud-init/templates/ldap.yml.tpl", {
      ldapSetting_id                         = local.ldapSetting_id
      ldapSetting_emailAttribute             = local.ldapSetting_emailAttribute
      ldapSetting_ldapUrl                    = local.ldapSetting_ldapUrl
      ldapSetting_managerDn                  = local.ldapSetting_managerDn
      ldapSetting_managerPassword            = local.ldapSetting_managerPassword
      ldapSetting_searchBase                 = local.ldapSetting_searchBase
      ldapSetting_searchFilter               = local.ldapSetting_searchFilter
      ldapSetting_searchSubTree              = local.ldapSetting_searchSubTree
      ldapSetting_userDnPattern              = local.ldapSetting_userDnPattern
      ldapSetting_allowUserToAccessProfile   = local.ldapSetting_allowUserToAccessProfile
      ldapGroupSettings_descriptionAttribute = local.ldapGroupSettings_descriptionAttribute
      ldapGroupSettings_filter               = local.ldapGroupSettings_filter
      ldapGroupSettings_groupBaseDn          = local.ldapGroupSettings_groupBaseDn
      ldapGroupSettings_groupMemberAttribute = local.ldapGroupSettings_groupMemberAttribute
      ldapGroupSettings_groupNameAttribute   = local.ldapGroupSettings_groupNameAttribute
      ldapGroupSettings_strategy             = local.ldapGroupSettings_strategy
      ldapGroupSettings_subTree              = local.ldapGroupSettings_subTree
    })

  }

  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/cloud-init/templates/database.yml.tpl", {
      db_fqdn                                = local.db_fqdn
      db_username                            = local.db_username
      db_password                            = local.db_password

    })

  }


  part {
    content_type = "text/cloud-config"
    content      = templatefile("${path.module}/cloud-init/templates/bootstrap-commands.yml.tpl", {

    })
  }

}

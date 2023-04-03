locals {
  account_ids                                              = data.vault_generic_secret.account_ids.data
  artifactory_account_ids                                  = local.secrets.artifactory_account_ids

  secrets                                                  = data.vault_generic_secret.secrets.data

  placement_subnet_cidrs                                   = values(zipmap(
    values(data.aws_subnet.placement).*.availability_zone,
    values(data.aws_subnet.placement).*.cidr_block
  ))
  placement_subnet_ids                                     = values(zipmap(
    values(data.aws_subnet.placement).*.availability_zone,
    values(data.aws_subnet.placement).*.id
  ))
  placement_subnet_pattern                                 = local.secrets.placement_subnet_pattern
  placement_vpc_pattern                                    = local.secrets.placement_vpc_pattern

  automation_subnet_cidrs                                  = values(zipmap(
    values(data.aws_subnet.automation).*.availability_zone,
    values(data.aws_subnet.automation).*.cidr_block
  ))
  automation_subnet_ids                                    = values(zipmap(
    values(data.aws_subnet.automation).*.availability_zone,
    values(data.aws_subnet.automation).*.id
  ))
  automation_subnet_pattern                                = local.secrets.automation_subnet_pattern
  automation_vpc_pattern                                   = local.secrets.automation_vpc_pattern

  certificate_arn                                          = lookup(local.secrets, "certificate_arn", null)
  dns_zone_name                                            = local.secrets.dns_zone_name
  load_balancer_dns_zone_name                              = local.secrets.load_balancer_dns_zone_name

  db_name                                                  = "${var.environment}-${var.service}-${var.db_engine}"
  db_subnet                                                = local.secrets.db_subnet
  db_username                                              = local.secrets.db_username
  db_password                                              = local.secrets.db_password
  db_port                                                  = local.secrets.db_port
  db_fqdn                                                  = "${var.service}db.${data.aws_route53_zone.selected.name}"

  ssh_keyname                                              = "${var.service}-${var.environment}"
  ssh_public_key                                           = local.secrets.public_key

  instance_cidrs                                           = concat(
    local.placement_subnet_cidrs,
  )

  ami_owner_id                                             = local.secrets.ami_owner_id

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
  ldapGroupSettings_descriptionAttribute                   = local.secrets.ldapGroupSettings_descriptionAttribute
  ldapGroupSettings_enabledLdap                            = local.ldapSetting_id
  ldapGroupSettings_filter                                 = local.secrets.ldapGroupSettings_filter
  ldapGroupSettings_groupBaseDn                            = local.secrets.ldapGroupSettings_groupBaseDn
  ldapGroupSettings_groupMemberAttribute                   = local.secrets.ldapGroupSettings_groupMemberAttribute
  ldapGroupSettings_groupNameAttribute                     = local.secrets.ldapGroupSettings_groupNameAttribute
  ldapGroupSettings_strategy                               = local.secrets.ldapGroupSettings_strategy
  ldapGroupSettings_subTree                                = local.secrets.ldapGroupSettings_subTree

}

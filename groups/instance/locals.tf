locals {
  secrets                    = data.vault_generic_secret.secrets.data
  security_kms_keys_data     = data.vault_generic_secret.security_kms_keys.data
  security_s3_buckets_data   = data.vault_generic_secret.security_s3_buckets.data
  security_efs_kms_keys_data = data.vault_generic_secret.security_efs_kms_keys_data.data

  placement_subnet_cidrs = values(zipmap(
    values(data.aws_subnet.placement).*.availability_zone,
    values(data.aws_subnet.placement).*.cidr_block
  ))
  placement_subnet_ids = values(zipmap(
    values(data.aws_subnet.placement).*.availability_zone,
    values(data.aws_subnet.placement).*.id
  ))
  placement_subnet_pattern = local.secrets.placement_subnet_pattern
  placement_vpc_pattern    = local.secrets.placement_vpc_pattern

  automation_subnet_ids = values(zipmap(
    values(data.aws_subnet.automation).*.availability_zone,
    values(data.aws_subnet.automation).*.id
  ))
  automation_subnet_pattern = local.secrets.automation_subnet_pattern
  automation_vpc_pattern    = local.secrets.automation_vpc_pattern
  concourse_access_cidrs    = local.secrets.concourse_access_cidrs

  artifactory_web_access = concat(local.placement_subnet_cidrs, [local.concourse_access_cidrs])

  dns_zone_name       = local.secrets.dns_zone_name
  dns_zone_is_private = local.secrets.dns_zone_is_private

  aws_route53_record_name = "${var.service}-${var.environment}.${data.aws_route53_zone.selected.name}"

  ssl_certificate_name = local.secrets.ssl_certificate_name

  create_ssl_certificate = local.ssl_certificate_name == "" ? true : false
  ssl_certificate_arn    = local.ssl_certificate_name == "" ? aws_acm_certificate_validation.certificate[0].certificate_arn : data.aws_acm_certificate.certificate[0].arn

  db_username = local.secrets.db_username
  db_password = local.secrets.db_password
  db_fqdn     = "${var.service}-db.${data.aws_route53_zone.selected.name}:${local.secrets.db_port}"

  ssh_keyname    = "${var.service}-${var.environment}"
  ssh_public_key = local.secrets.public_key

  ami_owner_id             = local.secrets.ami_owner_id
  account_id               = local.secrets.ami_owner_id
  artifactory_access_token = local.secrets.artifactory_access_token

  ldap_setting_key                           = "ldap1"
  ldap_setting_email_attribute               = local.secrets.ldap_setting_email_attribute
  ldap_setting_ldap_url                      = local.secrets.ldap_setting_ldap_url
  ldap_setting_managerdn                     = local.secrets.ldap_setting_managerdn
  ldap_setting_manager_password              = local.secrets.ldap_setting_manager_password
  ldap_setting_search_base                   = local.secrets.ldap_setting_search_base
  ldap_setting_search_filter                 = local.secrets.ldap_setting_search_filter
  ldap_setting_search_subtree                = local.secrets.ldap_setting_search_subtree
  ldap_setting_allow_user_to_access_profile  = local.secrets.ldap_setting_allow_user_to_access_profile
  ldap_group_settings_description_attribute  = local.secrets.ldap_group_settings_description_attribute
  ldap_group_settings_filter                 = local.secrets.ldap_group_settings_filter
  ldap_group_settings_group_basedn           = local.secrets.ldap_group_settings_group_basedn
  ldap_group_settings_group_member_attribute = local.secrets.ldap_group_settings_group_member_attribute
  ldap_group_settings_group_name_attribute   = local.secrets.ldap_group_settings_group_name_attribute
  ldap_group_settings_strategy               = local.secrets.ldap_group_settings_strategy
  ldap_group_settings_subtree                = local.secrets.ldap_group_settings_subtree

  efs_access_point_id = module.efs_file_system.efs_access_point_ids["${var.efs_artifacts_access_point_name}"].id

  parameter_store_secrets = merge(
    {
      "db_username"                   = local.secrets.db_username
      "db_password"                   = local.secrets.db_password
      "ldap_setting_managerdn"        = local.secrets.ldap_setting_managerdn
      "ldap_setting_manager_password" = local.secrets.ldap_setting_manager_password
      "artifactory_license"           = local.secrets.artifactory_license
      "admin_password"                = local.secrets.admin_password
    }
  )

  db_username_param_name                     = "/${var.service}/${var.environment}/db_username"
  db_password_param_name                     = "/${var.service}/${var.environment}/db_password"
  admin_password_param_name                  = "/${var.service}/${var.environment}/admin_password"
  # ldap_setting_managerdn_param_name        = "/${var.service}/${var.environment}/ldap_setting_managerdn"
  # ldap_setting_manager_password_param_name = "/${var.service}/${var.environment}/ldap_setting_manager_password"
  artifactory_license_param_name             = "/${var.service}/${var.environment}/artifactory_license"
}

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
  automation_subnet_ids = values(zipmap(
    values(data.aws_subnet.automation).*.availability_zone,
    values(data.aws_subnet.automation).*.id
  ))

  placement_subnet_pattern  = local.secrets.placement_subnet_pattern
  placement_vpc_pattern     = local.secrets.placement_vpc_pattern
  automation_subnet_pattern = local.secrets.automation_subnet_pattern
  automation_vpc_pattern    = local.secrets.automation_vpc_pattern
  concourse_access_cidrs    = local.secrets.concourse_access_cidrs
  artifactory_web_access    = concat(local.placement_subnet_cidrs, [local.concourse_access_cidrs])
  dns_zone_name             = local.secrets.dns_zone_name
  dns_zone_is_private       = local.secrets.dns_zone_is_private
  aws_route53_record_name   = "${local.base_path}.${data.aws_route53_zone.selected.name}"
  ssl_certificate_name      = local.secrets.ssl_certificate_name
  create_ssl_certificate    = local.ssl_certificate_name == "" ? true : false
  ssl_certificate_arn       = local.ssl_certificate_name == "" ? aws_acm_certificate_validation.certificate[0].certificate_arn : data.aws_acm_certificate.certificate[0].arn
  db_fqdn                   = "${var.service}-db.${data.aws_route53_zone.selected.name}:${local.secrets.db_port}"
  ssh_public_key            = local.secrets.public_key
  ami_owner_id              = local.secrets.ami_owner_id
  account_id                = local.secrets.ami_owner_id
  efs_access_point_id       = module.efs_file_system.efs_access_point_ids[var.efs_artifacts_access_point_name].id
  param_base_path           = "/${var.service}/${var.environment}"
  base_path                 = "${var.service}-${var.environment}"

  parameter_store_secrets = merge(
    {
      "db_username"                   = local.secrets.db_username
      "db_password"                   = local.secrets.db_password
      "artifactory_license"           = local.secrets.artifactory_license
      "admin_password"                = local.secrets.admin_password
      "db_masterkey"                  = local.secrets.db_masterkey
      "artifactory_access_token"      = local.secrets.artifactory_access_token
    }
  )

  db_username_param_name                   = "${local.param_base_path}/db_username"
  db_password_param_name                   = "${local.param_base_path}/db_password"
  db_masterkey_param_name                  = "${local.param_base_path}/db_masterkey"
  admin_password_param_name                = "${local.param_base_path}/admin_password"
  artifactory_license_param_name           = "${local.param_base_path}/artifactory_license"
  artifactory_access_token_param_name      = "${local.param_base_path}/artifactory_access_token"
}

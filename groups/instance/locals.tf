locals {
  secrets                    = data.vault_generic_secret.secrets.data
  security_kms_keys_data     = data.vault_generic_secret.security_kms_keys.data
  security_s3_buckets_data   = data.vault_generic_secret.security_s3_buckets.data
  security_efs_kms_keys_data = data.vault_generic_secret.security_efs_kms_keys_data.data

  resource_prefix = "${var.environment}-${var.service}"

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

  concourse_access_cidrs = local.secrets.concourse_access_cidrs
  web_access_cidrs       = concat(local.placement_subnet_cidrs, [local.concourse_access_cidrs])

  web_access_cidrs_map = {
    for idx, cidr in local.web_access_cidrs : idx => cidr
  }

  web_access_prefix_list_ids = [
    data.aws_ec2_managed_prefix_list.administration.id,
    data.aws_ec2_managed_prefix_list.concourse.id
  ]

  dns_zone_name           = local.secrets.dns_zone_name
  aws_route53_record_name = "${local.resource_prefix}.${data.aws_route53_zone.selected.name}"
  ssl_certificate_name    = local.secrets.ssl_certificate_name
  create_ssl_certificate  = local.ssl_certificate_name == "" ? true : false
  ssl_certificate_arn     = local.ssl_certificate_name == "" ? aws_acm_certificate_validation.certificate[0].certificate_arn : data.aws_acm_certificate.certificate[0].arn

  ami_owner_id        = local.secrets.ami_owner_id
  account_id          = local.secrets.ami_owner_id
  db_fqdn             = "${local.resource_prefix}-db.${data.aws_route53_zone.selected.name}:${local.secrets.db_port}"
  efs_access_point_id = module.efs_file_system.efs_access_point_ids[var.efs_artifacts_access_point_name].id
  ssh_public_key      = local.secrets.public_key

  parameter_store_secrets = {
    "db_username"              = local.secrets.db_username
    "db_password"              = local.secrets.db_password
    "artifactory_license"      = local.secrets.artifactory_license
    "admin_password"           = local.secrets.admin_password
    "db_masterkey"             = local.secrets.db_masterkey
    "artifactory_access_token" = local.secrets.artifactory_access_token
  }

  param_base_path                     = "/${local.resource_prefix}"
  db_username_param_name              = "${local.param_base_path}/db_username"
  db_password_param_name              = "${local.param_base_path}/db_password"
  db_masterkey_param_name             = "${local.param_base_path}/db_masterkey"
  admin_password_param_name           = "${local.param_base_path}/admin_password"
  artifactory_license_param_name      = "${local.param_base_path}/artifactory_license"
  artifactory_access_token_param_name = "${local.param_base_path}/artifactory_access_token"

  cloudwatch_collect_list_json    = length(var.cloudwatch_logs_collected) > 0 ? jsonencode(
    [
      for log in var.cloudwatch_logs_collected : {
        "file_path" = "${var.artifactory_base_path}/var/log/${log.name}",
        "log_group_name" = aws_cloudwatch_log_group.artifactory.name,
        "log_stream_name" = "{instance_id}-${log.name}",
        "timestamp_format" = log.timestamp_format
      }
    ]) : null
  cloudwatch_log_collection_enabled = length(var.cloudwatch_logs_collected) > 0 ? true : false

  ebs_additional_volumes = [
    for block_device in data.aws_ami.artifactory.block_device_mappings :
    block_device if block_device.device_name != data.aws_ami.artifactory.root_device_name &&
    length(block_device.ebs) != 0
  ]
}

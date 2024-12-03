data "cloudinit_config" "artifactory" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = "#cloud-config"
  }

  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/cloud-init/templates/master_key.tpl", {
      aws_command             = var.aws_command
      region                  = var.region
      db_masterkey_param_name = local.db_masterkey_param_name
    })
    merge_type = var.user_data_merge_strategy
  }

  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/cloud-init/templates/system_yaml.tpl", {
      aws_command            = var.aws_command
      region                 = var.region
      db_username_param_name = local.db_username_param_name
      db_password_param_name = local.db_password_param_name
      db_fqdn                = local.db_fqdn
      service                = var.service
    })
    merge_type = var.user_data_merge_strategy
  }

  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/cloud-init/templates/xml_config.tpl", {
      aws_command                         = var.aws_command
      region                              = var.region
      artifactory_access_token_param_name = local.artifactory_access_token_param_name
    })
    merge_type = var.user_data_merge_strategy
  }

  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/cloud-init/templates/license.tpl", {
      aws_command                    = var.aws_command
      region                         = var.region
      artifactory_license_param_name = local.artifactory_license_param_name
    })
    merge_type = var.user_data_merge_strategy
  }

  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/cloud-init/templates/admin_pw.tpl", {
      aws_command               = var.aws_command
      region                    = var.region
      admin_password_param_name = local.admin_password_param_name
    })
    merge_type = var.user_data_merge_strategy
  }

  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/cloud-init/templates/efs_repo_path.tpl", {
    })
    merge_type = var.user_data_merge_strategy
  }

  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/cloud-init/templates/bootstrap_commands.tpl", {
      efs_filesystem_id   = module.efs_file_system.efs_filesystem_id
      efs_access_point_id = local.efs_access_point_id
      lvm_block_devices   = var.lvm_block_devices
    })
    merge_type = var.user_data_merge_strategy
  }

  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/cloud-init/templates/cloudwatch-agent.tpl", {
      cloudwatch_collect_list_json      = local.cloudwatch_collect_list_json
      cloudwatch_log_collection_enabled = local.cloudwatch_log_collection_enabled
      cloudwatch_namespace              = local.resource_prefix
    })
    merge_type = var.user_data_merge_strategy
  }
}

resource "aws_launch_template" "artifactory_launch_template" {
  name          = "${local.base_path}-launch-template"
  image_id      = data.aws_ami.artifactory_ami.id
  instance_type = var.default_instance_type
  key_name      = local.base_path
  user_data     = data.cloudinit_config.artifactory.rendered

  lifecycle {
    create_before_destroy = true
  }

  network_interfaces {
    security_groups = [aws_security_group.instance_security_group.id]
    subnet_id       = tolist(data.aws_subnets.placement.ids)[1]
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.artifactory_instance_profile.name
  }

  block_device_mappings {
    device_name = var.block_device_name
    ebs {
      delete_on_termination = var.ebs_root_delete_on_termination
      iops                  = var.ebs_root_iops
      encrypted             = var.ebs_root_encrypted
      kms_key_id            = aws_kms_key.artifactory_kms_key.arn
      volume_size           = var.ebs_root_volume_size
      throughput            = var.ebs_root_throughput
      volume_type           = var.ebs_root_volume_type
    }
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${local.base_path}"
    }
  }

  tag_specifications {
    resource_type = "volume"

    tags = {
      Name        = "${local.base_path}-root-volume"
      Service     = var.service
      Environment = var.environment
      Snapshot    = "Daily"
      RootDevice  = "True"
    }
  }

  tags = {
    Name = "${local.base_path}-launch-template"
  }
}

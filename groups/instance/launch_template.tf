resource "aws_launch_template" "artifactory_launch_template" {
  name          = "${var.service}-${var.environment}-launch-template"
  image_id      = data.aws_ami.artifactory_ami.id
  instance_type = var.default_instance_type
  key_name      = local.ssh_keyname
  user_data     = data.cloudinit_config.artifactory.rendere

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

  tags = {
    Name = "${var.service}-${var.environment}-launch-template"
  }
}

resource "aws_autoscaling_group" "artifactory_asg" {
  name                      = "${local.resource_prefix}-asg"
  max_size                  = var.asg_max_size
  min_size                  = var.asg_min_size
  default_cooldown          = var.asg_default_cooldown
  health_check_grace_period = var.asg_health_check_grace_period
  health_check_type         = var.asg_health_check_type
  desired_capacity          = var.asg_desired_capacity
  vpc_zone_identifier       = data.aws_subnets.placement.ids

  target_group_arns = [
    aws_lb_target_group.front_end_8082.arn
  ]

  termination_policies = [
    var.asg_termination_policies
  ]

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances"
  ]

  launch_template {
    id      = aws_launch_template.artifactory_launch_template.id
    version = "${var.asg_launch_template_version}"
  }

  tag {
    key                 = "Name"
    value               = local.resource_prefix
    propagate_at_launch = true
  }

  tag {
    key                 = "Service"
    value               = var.service
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }

  tag {
    key                 = "Managed By Terraform"
    value               = "true"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_attachment" "artifactory_asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.artifactory_asg.id
  lb_target_group_arn    = aws_lb_target_group.front_end_8082.arn
}

resource "aws_key_pair" "artifactory" {
  key_name   = local.resource_prefix
  public_key = local.ssh_public_key
}

resource "aws_launch_template" "artifactory_launch_template" {
  name          = "${local.resource_prefix}-launch-template"
  image_id      = data.aws_ami.artifactory_ami.id
  instance_type = var.default_instance_type
  key_name      = local.resource_prefix
  user_data     = data.cloudinit_config.artifactory.rendered

  network_interfaces {
    security_groups = [aws_security_group.ec2.id]
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
      kms_key_id            = aws_kms_key.artifactory.arn
      volume_size           = var.ebs_root_volume_size
      throughput            = var.ebs_root_throughput
      volume_type           = var.ebs_root_volume_type
    }
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = local.resource_prefix
    }
  }

  tag_specifications {
    resource_type = "volume"

    tags = {
      Name        = "${local.resource_prefix}-root-volume"
      Service     = var.service
      Environment = var.environment
      Snapshot    = "Daily"
      RootDevice  = "True"
    }
  }

  tags = {
    Name = "${local.resource_prefix}-launch-template"
  }
}

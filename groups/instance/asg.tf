resource "aws_autoscaling_group" "artifactory_asg" {
  name                      = "${var.environment}-${var.service}-asg"
  max_size                  = var.asg_max_size
  min_size                  = var.asg_min_size
  default_cooldown          = var.asg_default_cooldown
  health_check_grace_period = var.asg_health_check_grace_period
  health_check_type         = var.asg_health_check_type
  desired_capacity          = var.asg_desired_capacity
  target_group_arns         = [aws_lb_target_group.front_end_8082.arn]
  vpc_zone_identifier       = tolist(data.aws_subnets.placement.ids)
  termination_policies      = [var.asg_termination_policies]
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
    key                 = "Account"
    value               = "${var.account_name}"
    propagate_at_launch = false
  }

  tag {
    key                 = "Region"
    value               = "${var.region}"
    propagate_at_launch = false
  }

  tag {
    key                 = "Name"
    value               = "${local.base_path}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Service"
    value               = "${var.service}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = "${var.environment}"
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

resource "aws_autoscaling_schedule" "scale_down" {
  desired_capacity       = var.asg_scale_down_desired_capacity
  min_size               = var.asg_scale_down_min_size
  max_size               = var.asg_scale_down_max_size
  recurrence             = var.asg_scale_down_recurrence
  scheduled_action_name  = "${var.environment}-${var.service}-scale-down"
  time_zone              = var.asg_time_zone
  autoscaling_group_name = aws_autoscaling_group.artifactory_asg.name
}

resource "aws_autoscaling_schedule" "scale_up" {
  desired_capacity       = var.asg_desired_capacity
  min_size               = var.asg_min_size
  max_size               = var.asg_max_size
  recurrence             = var.asg_scale_up_recurrence
  time_zone              = var.asg_time_zone
  scheduled_action_name  = "${var.environment}-${var.service}-scale-up"
  autoscaling_group_name = aws_autoscaling_group.artifactory_asg.name
}

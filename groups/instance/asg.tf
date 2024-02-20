resource "aws_autoscaling_group" "artifactory_asg" {
  name                      = "${var.environment}-${var.service}-asg"  
  availability_zones        = var.region
  desired_capacity          = 1
  max_size                  = 1
  min_size                  = 1
  health_check_grace_period = 150
  health_check_type         = "EC2"
  termination_policies      = ["OldestInstance"]
  vpc_zone_identifier       = tolist(data.aws_subnets.placement.ids)[1]
  load_balancers            = [aws_lb.artifactory.name]
  enabled_metrics           = [
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
    id      = aws_launch_template.artifactory_asg_launch_template.id
    version = "$Latest"
  }
  
  tags = {
    Name = "${var.service}-${var.environment}-asg"
  }
}

resource "aws_launch_template" "artifactory_asg_launch_template" {
  name             = "${var.service}-${var.environment}-asg-launch-template"
  image_id         = data.aws_ami.artifactory_ami.id
  instance_type    = var.default_instance_type
  security_groups  = [aws_security_group.instance_security_group.id]
  key_name         = local.ssh_keyname
  user_data_base64 = data.cloudinit_config.artifactory.rendered
  
  lifecycle {
    create_before_destroy = true
  }

  ebs {
    delete_on_termination = var.ebs_root_delete_on_termination
    iops                  = var.ebs_root_iops
    #encrypted             = var.ebs_root_encrypted
    #kms_key_id            = aws_kms_key.artifactory_kms_key.arn
    volume_size           = var.ebs_root_volume_size
    throughput            = var.ebs_root_throughput
    volume_type           = var.ebs_root_volume_type

    tags = {
      Name        = "${var.service}-${var.environment}-root-volume"
      Service     = var.service
      Environment = var.environment
      Snapshot    = "Daily"
      RootDevice  = "True" 
    }
  }

  tags = {
    Name = "${var.service}-${var.environment}-asg-launch-template"
  }
}

resource "aws_autoscaling_policy" "artifactory_asg_policy" {
  name                   = "${var.environment}-${var.service}-asg-policy"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.artifactory_asg.id
  
  # CPU Utilization is above 80
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = "80"
  }
  
  tags = {
    Name = "${var.service}-${var.environment}-asg-policy"
  }
}

resource "aws_autoscaling_attachment" "artifactory_asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.artifactory_asg.id
  lb_target_group_arn    = aws_lb_target_group.front_end_8082.arn
}

resource "aws_autoscaling_schedule" "scale_down" {
  scheduled_action_name  = "${var.environment}-${var.service}-scale-down"
  min_size               = 0
  max_size               = 0
  recurrence             = var.asg_scale_down
  desired_capacity       = 1
  autoscaling_group_name = aws_autoscaling_group.artifactory_asg.name
}

resource "aws_autoscaling_schedule" "scale_up" {
  scheduled_action_name  = "${var.environment}-${var.service}-scale-up"
  min_size               = 1
  max_size               = 1
  recurrence             = var.asg_scale_up
  desired_capacity       = 1
  autoscaling_group_name = aws_autoscaling_group.artifactory_asg.name
}

# resource "aws_autoscaling_group" "artifactory_asg" {
#   name                      = "${var.environment}-${var.service}-asg"  
#   availability_zones        = [var.region]
#   desired_capacity          = 1
#   max_size                  = 1
#   min_size                  = 1
#   health_check_grace_period = 150
#   health_check_type         = "EC2"
#   termination_policies      = ["OldestInstance"]
#   #vpc_zone_identifier       = [tolist(data.aws_subnets.placement.ids)[1]]
#   load_balancers            = [aws_lb.artifactory.name]
#   enabled_metrics           = [
#     "GroupMinSize",
#     "GroupMaxSize",
#     "GroupDesiredCapacity",
#     "GroupInServiceInstances",
#     "GroupPendingInstances",
#     "GroupStandbyInstances",
#     "GroupTerminatingInstances",
#     "GroupTotalInstances"
#   ]
  
#   launch_template {
#     id      = aws_launch_template.artifactory_launch_template.id
#     version = "$Latest"
#   }
  
#   # tags = {
#   #   Name = "${var.service}-${var.environment}-asg"
#   # }
# }

# resource "aws_autoscaling_policy" "artifactory_asg_policy" {
#   name                   = "${var.environment}-${var.service}-asg-policy"
#   policy_type            = "TargetTrackingScaling"
#   autoscaling_group_name = aws_autoscaling_group.artifactory_asg.id
  
#   # CPU Utilization is above 80
#   target_tracking_configuration {
#     predefined_metric_specification {
#       predefined_metric_type = "ASGAverageCPUUtilization"
#     }
#     target_value = "80"
#   }
  
#   # tag = {
#   #   Name = "${var.service}-${var.environment}-asg-policy"
#   # }
# }

# resource "aws_autoscaling_attachment" "artifactory_asg_attachment" {
#   autoscaling_group_name = aws_autoscaling_group.artifactory_asg.id
#   lb_target_group_arn    = aws_lb_target_group.front_end_8082.arn
# }

# resource "aws_autoscaling_schedule" "scale_down" {
#   scheduled_action_name  = "${var.environment}-${var.service}-scale-down"
#   min_size               = 1
#   max_size               = 1
#   recurrence             = var.asg_scale_down
#   desired_capacity       = 1
#   autoscaling_group_name = aws_autoscaling_group.artifactory_asg.name
# }

# resource "aws_autoscaling_schedule" "scale_up" {
#   scheduled_action_name  = "${var.environment}-${var.service}-scale-up"
#   min_size               = 1
#   max_size               = 1
#   recurrence             = var.asg_scale_up
#   desired_capacity       = 1
#   autoscaling_group_name = aws_autoscaling_group.artifactory_asg.name
# }

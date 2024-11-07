output "alb_dns_name" {
  description = "Returns the AWS DNS name for the ALB"
  value       = aws_lb.artifactory.dns_name
}

output "alb_name" {
  description = "Returns the name of the deployed ALB"
  value       = aws_lb.artifactory.name
}

output "alb_security_group_id" {
  description = "Returns the id of the security group attached to the ALB"
  value       = aws_security_group.alb.id
}

output "asg_name" {
  description = "Returns the name of the deployed ASG"
  value       = aws_autoscaling_group.artifactory_asg.name
}

output "asg_security_group_id" {
  description = "Returns the id of the security group attached to ASG EC2 instances"
  value       = aws_security_group.ec2.id
}

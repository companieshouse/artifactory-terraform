output "vpc_id" {
  description = "Returns the id of the VPC used during deployment"
  value       = data.aws_vpc.placement.id
}

output "subnet_ids" {
  description = "Returns a list of the subnet ids used during deployment"
  value       = local.placement_subnet_ids
}

output "security_group_id" {
  description = "Returns the id of the RDS security group"
  value       = aws_security_group.rds.id
}

output "rds_route53_name" {
  description = "Returns the Route53 name, or FQDN, for the RDS instance"
  value       = nonsensitive(aws_route53_record.db.name)
}

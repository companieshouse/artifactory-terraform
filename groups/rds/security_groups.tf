resource "aws_security_group" "rds" {
  name        = "${local.resource_prefix}-rds"
  description = "Security group for ${local.resource_prefix} artifactory RDS"
  vpc_id      = data.aws_vpc.placement.id

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${local.resource_prefix}-rds"
  }
}

resource "aws_vpc_security_group_egress_rule" "artifactory" {
  security_group_id = aws_security_group.rds.id
  description       = "Permit egress from Artifactory RDS"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "artifactory" {
  for_each = toset(local.placement_subnet_cidrs)

  security_group_id = aws_security_group.rds.id
  description       = "Permit access from Artifactor subnet ${each.value}"
  cidr_ipv4         = each.value
  from_port         = var.db_port
  ip_protocol       = "tcp"
  to_port           = var.db_port
}

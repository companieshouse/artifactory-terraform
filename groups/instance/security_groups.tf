resource "aws_security_group" "ec2" {
  name        = "${local.resource_prefix}-instance"
  description = "Security group for ${local.resource_prefix} EC2 instances"
  vpc_id      = data.aws_vpc.placement.id

  tags = {
    Name = "${local.resource_prefix}-instance"
  }
}

resource "aws_vpc_security_group_egress_rule" "ec2_egress" {
  security_group_id = aws_security_group.ec2.id
  description       = "Permit egress from Artifactory EC2"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "alb_ingress" {
  security_group_id            = aws_security_group.ec2.id
  description                  = "Permit application access from the ALB"
  from_port                    = 8081
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.alb.id
  to_port                      = 8082
}

resource "aws_security_group" "alb" {
  name        = "${local.resource_prefix}-lb"
  description = "Security group for ${local.resource_prefix} ALB"
  vpc_id      = data.aws_vpc.placement.id

  tags = {
    Name = "${var.environment}-${var.service}-lb"
  }
}

resource "aws_vpc_security_group_egress_rule" "alb_egress" {
  security_group_id = aws_security_group.alb.id
  description       = "Permit egress from Artifactory ALB"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "http_ingress_cidrs" {
  for_each = local.web_access_cidrs_map

  security_group_id = aws_security_group.alb.id
  description       = "Permit HTTP ingress from ${each.value}"
  cidr_ipv4         = each.value
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "https_ingress_cidrs" {
  for_each = local.web_access_cidrs_map

  security_group_id = aws_security_group.alb.id
  description       = "Permit HTTP ingress from ${each.value}"
  cidr_ipv4         = each.value
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "http_ingress_prefixlist" {
  for_each = toset(local.web_access_prefix_list_ids)

  security_group_id = aws_security_group.alb.id
  description       = "Permit HTTP ingress from ${each.value}"
  from_port         = 80
  ip_protocol       = "tcp"
  prefix_list_id    = each.value
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "https_ingress_prefixlist" {
  for_each = toset(local.web_access_prefix_list_ids)

  security_group_id = aws_security_group.alb.id
  description       = "Permit HTTP ingress from ${each.value}"
  from_port         = 443
  ip_protocol       = "tcp"
  prefix_list_id    = each.value
  to_port           = 443
}

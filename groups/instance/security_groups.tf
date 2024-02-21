resource "aws_security_group" "instance_security_group" {
  name        = "${var.environment}-${var.service}-instance"
  description = "Allow TLS inbound traffic"
  vpc_id      = data.aws_vpc.placement.id

  ingress {
    description     = "Artifactory"
    from_port       = 8081
    to_port         = 8082
    protocol        = "tcp"
    cidr_blocks     = [local.concourse_access_cidrs]
    prefix_list_ids = [data.aws_ec2_managed_prefix_list.administration.id]
    security_groups = [aws_security_group.alb_security_group.id]
  }

  ingress {
    description     = "SSH"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = [local.concourse_access_cidrs]
    prefix_list_ids = [data.aws_ec2_managed_prefix_list.administration.id]
  }

  ingress {
    description     = "Access for EFS"
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_security_group.id]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-${var.service}-instance"
    Type = "security-group"
  }
}

resource "aws_security_group" "alb_security_group" {
  name        = "${var.environment}-${var.service}-lb"
  description = "Restricts access for ${var.service}-${var.environment} lb artifactory nodes"
  vpc_id      = data.aws_vpc.placement.id

  ingress {
    description     = "lb HTTP ingress from admin and concourse CIDRs"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = local.artifactory_web_access
    prefix_list_ids = [data.aws_ec2_managed_prefix_list.administration.id]
  }

  ingress {
    description     = "lb HTTPS ingress from admin and concourse CIDRs"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks     = local.artifactory_web_access
    prefix_list_ids = [data.aws_ec2_managed_prefix_list.administration.id]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-${var.service}-lb"
    Type = "security-group"
  }
}

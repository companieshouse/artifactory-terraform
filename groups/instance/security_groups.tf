resource "aws_security_group" "instance_security_group" {
  name        = "${var.environment}-${var.service}-instance"
  description = "Allow TLS inbound traffic"
  vpc_id      = data.aws_vpc.placement.id

  ingress {
    description      = "Artifactory Ingress from permitted CIDRs"
    from_port        = 8081
    to_port          = 8081
    protocol         = "tcp"
    cidr_blocks      = local.instance_cidrs

  }

  ingress {
    description      = "SSH Ingress from permitted CIDRs"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = local.instance_cidrs
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.environment}-${var.service}-instance"
    Service = var.service
    Type    = "security-group"
  }

}

resource "aws_security_group" "instance_security_group" {
  name        = "${var.environment}-${var.service}-instance"
  description = "Allow TLS inbound traffic"
  vpc_id      = data.aws_vpc.placement.id

  ingress {
    description      = "Ingress from permitted CIDRs"
    from_port        = 8081
    to_port          = 8081
    protocol         = "tcp"
    cidr_blocks      = data.aws_ec2_managed_prefix_list.administration
  }

  ingress {
    description      = "Ingress from permitted CIDRs"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = data.aws_ec2_managed_prefix_list.administration
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

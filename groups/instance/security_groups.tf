resource "aws_security_group" "instance_security_group" {
  name        = "${var.environment}-${var.service}-instance"
  description = "Allow TLS inbound traffic"
  vpc_id      = data.aws_vpc.placement.id

  ingress {
    description      = "Artifactory Ingress from permitted CIDRs"
    from_port        = 8081
    to_port          = 8082
    protocol         = "tcp"
    cidr_blocks      = local.instance_cidrs
    prefix_list_ids = [data.aws_ec2_managed_prefix_list.administration.id,
    ]
  }

  ingress {
    description      = "SSH Ingress from permitted CIDRs"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = local.instance_cidrs
    prefix_list_ids = [data.aws_ec2_managed_prefix_list.administration.id,
    ]
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
    Type    = "security-group"
  }

}

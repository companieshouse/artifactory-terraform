resource "aws_security_group" "db_security_group" {
  name        = "${var.environment}-${var.service}-rds"
  description = "Allow TLS inbound traffic"
  vpc_id      = data.aws_vpc.placement.id

  ingress {
    description      = "Ingress from permitted CIDRs"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = concat(local.placement_subnet_cidrs, local.automation_subnet_cidrs)
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.environment}-${var.service}-rds"
    Service = var.service
    Type    = "security-group"
  }

}

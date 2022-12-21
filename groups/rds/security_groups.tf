resource "aws_security_group" "db_security_group" {
  name        = "${var.environment}-${var.service}-rds"
  description = "Restricts access for ${var.service}-${var.environment} artifactory nodes"
  vpc_id      = data.aws_vpc.placement.id

  ingress {
    description      = "MySQL ingress from permitted CIDRs"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
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

resource "aws_key_pair" "artifactory" {
  key_name   = local.ssh_keyname
  public_key = local.ssh_public_key
}

resource "aws_instance" "artifactory" {
  launch_template {
    id      = aws_launch_template.artifactory_launch_template.id
    version = "${var.asg_launch_template_version}"
  }

  volume_tags = {
    Name        = "${var.service}-${var.environment}-root-volume"
    Service     = var.service
    Environment = var.environment
    Snapshot    = "Daily"
    RootDevice  = "True"
  }

  tags = {
    Name = "${var.environment}-${var.service}"
  }
}

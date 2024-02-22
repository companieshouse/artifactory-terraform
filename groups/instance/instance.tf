resource "aws_key_pair" "artifactory" {
  key_name   = local.ssh_keyname
  public_key = local.ssh_public_key
}

resource "aws_instance" "artifactory" {
  user_data_base64 = data.cloudinit_config.artifactory.rendered
  launch_template {
    id      = aws_launch_template.artifactory_launch_template.id
    version = "$Latest"
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

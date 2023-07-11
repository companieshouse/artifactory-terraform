resource "aws_key_pair" "artifactory" {
  key_name   = local.ssh_keyname
  public_key = local.ssh_public_key
}
resource "aws_instance" "artifactory" {
  ami                    = "ami-0d2c8488a7bb1be34"
  #ami                    = data.aws_ami.artifactory_ami.id
  instance_type          = var.default_instance_type
  subnet_id              = tolist(data.aws_subnet_ids.placement.ids)[0]
  vpc_security_group_ids = [aws_security_group.instance_security_group.id]
  key_name               = local.ssh_keyname
  user_data_base64       = data.cloudinit_config.artifactory.rendered
  iam_instance_profile   = aws_iam_instance_profile.artifactory_instance_profile.name
  tags = {
    Name = "${var.environment}-${var.service}"
  }
}


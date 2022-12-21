resource "aws_instance" "artifactory" {
  ami                    = var.ami
  instance_type          = var.default_instance_type
  subnet_id              = local.placement_subnet_ids
  vpc_security_group_ids = [aws_security_group.instance_security_group.id]
  key_name               = var.ssh_keyname
  user_data_base64       = data.cloudinit_config.artifactory.*.rendered

}


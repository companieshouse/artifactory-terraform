resource "aws_key_pair" "artifactory" {
  key_name   = local.ssh_keyname
  public_key = local.ssh_public_key
}

resource "aws_instance" "artifactory" {
  ami                    = data.aws_ami.artifactory_ami.id
  instance_type          = var.default_instance_type
  subnet_id              = tolist(data.aws_subnet_ids.placement.ids)[0]
  vpc_security_group_ids = [aws_security_group.instance_security_group.id]
  key_name               = local.ssh_keyname
  user_data_base64       = data.cloudinit_config.artifactory.rendered
  iam_instance_profile   = aws_iam_instance_profile.artifactory_instance_profile.name
  
  ebs_block_device {
    delete_on_termination = var.ebs_delete_on_termination
    device_name           = "/dev/xvdb"
    encrypted             = var.ebs_encrypted
    kms_key_id            = local.ebs_kms_key_id
    iops                  = var.ebs_iops
    volume_size           = var.ebs_volume_size
    volume_type           = var.ebs_volume_type

    tags = {
      Name        = "${var.service}-${var.environment}-data-ebs-volume-xvdb"
      Service     = "${var.service}"
      Environment = "${var.environment}"
      Snapshot    = "Daily"
      RootDevice  = "False" 
    }
  }

  tags = {
    Name = "${var.environment}-${var.service}"
  }
}

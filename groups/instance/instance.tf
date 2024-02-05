resource "aws_key_pair" "artifactory" {
  key_name   = local.ssh_keyname
  public_key = local.ssh_public_key
}

resource "aws_instance" "artifactory" {
  ami                    = data.aws_ami.artifactory_ami.id
  instance_type          = var.default_instance_type
  subnet_id              = tolist(data.aws_subnets.placement.ids)[1]
  vpc_security_group_ids = [aws_security_group.instance_security_group.id]
  key_name               = local.ssh_keyname
  user_data_base64       = data.cloudinit_config.artifactory.rendered
  iam_instance_profile   = aws_iam_instance_profile.artifactory_instance_profile.name
  
  root_block_device {
    delete_on_termination = var.ebs_root_delete_on_termination
    iops                  = var.ebs_root_iops    
    #encrypted             = var.ebs_root_encrypted
    #kms_key_id            = aws_kms_key.artifactory_kms_key.key_id
    volume_size           = var.ebs_root_volume_size
    throughput            = var.ebs_root_throughput
    volume_type           = var.ebs_root_volume_type

    tags = {
      Name        = "${var.service}-${var.environment}-root-volume"
      Service     = var.service
      Environment = var.environment
      Snapshot    = "Daily"
      RootDevice  = "True" 
    }
  }

  tags = {
    Name = "${var.environment}-${var.service}"
  }
}

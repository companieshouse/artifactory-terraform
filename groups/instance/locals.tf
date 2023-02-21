locals {
  account_ids             = data.vault_generic_secret.account_ids.data
  artifactory_account_ids = local.secrets.artifactory_account_ids

  secrets     = data.vault_generic_secret.secrets.data

  placement_subnet_cidrs = values(zipmap(
    values(data.aws_subnet.placement).*.availability_zone,
    values(data.aws_subnet.placement).*.cidr_block
  ))
  placement_subnet_ids = values(zipmap(
    values(data.aws_subnet.placement).*.availability_zone,
    values(data.aws_subnet.placement).*.id
  ))
  placement_subnet_pattern = local.secrets.placement_subnet_pattern
  placement_vpc_pattern    = local.secrets.placement_vpc_pattern

  automation_subnet_cidrs = values(zipmap(
    values(data.aws_subnet.automation).*.availability_zone,
    values(data.aws_subnet.automation).*.cidr_block
  ))
  automation_subnet_ids = values(zipmap(
    values(data.aws_subnet.automation).*.availability_zone,
    values(data.aws_subnet.automation).*.id
  ))
  automation_subnet_pattern   = local.secrets.automation_subnet_pattern
  automation_vpc_pattern      = local.secrets.automation_vpc_pattern


  certificate_arn             = lookup(local.secrets                                , "certificate_arn", null)
  dns_zone_name               = local.secrets.dns_zone_name
  load_balancer_dns_zone_name = local.secrets.load_balancer_dns_zone_name

  db_name                     = "${var.environment}-${var.service}-${var.db_engine}"
  db_subnet                   = local.secrets.db_subnet
  db_username                 = local.secrets.db_username
  db_password                 = local.secrets.db_password
  db_port                     = local.secrets.db_port

  ssh_keyname                 = "${var.service}-${var.environment}"
  ssh_public_key              = local.secrets.public_key

  instance_cidrs              = concat(
    local.placement_subnet_cidrs,
  )

  ami_owner_id = local.secrets.ami_owner_id

  artifactory_config = <<-END
    ${jsonencode({
      write_files = [
        {
          path        = "/opt/jfrog/artifactory/var/etc/artifactory/artifactory.config.xml"
          permissions = "0644"
          owner       = "root:root"
          encoding    = "b64"
          content     = filebase64("${path.module}/artifactory.config.xml")
        },
      ]
    })}
  END



}

data "cloudinit_config" "artifactory" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = "#cloud-config"
  }

  part {
    content_type = "text/cloud-config"
    content      = "fqdn: ${instance_fqdn}"
  }

  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/cloud-init/templates/${var.service}.yml.tpl", {
      instance_fqdn = "${var.service}.${var.environment}.${data.aws_route53_zone.selected.name}"
      db_fqdn       = "${var.service}db.${data.aws_route53_zone.selected.name}"
      service       = var.service
      dns_zone      = data.aws_route53_zone.selected.name
      db_port       = local.db_port
      db_name       = local.db_name
      db_username   = local.db_username
      db_password   = local.db_password

    })
  }


  part {
    content_type = "text/cloud-config"
    content      = templatefile("${path.module}/cloud-init/templates/bootstrap-commands.yml.tpl")
  }

}

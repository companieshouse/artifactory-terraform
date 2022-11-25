data "cloudinit_config" "artifactory" {
  count         = var.instance_count
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = "#cloud-config"
  }

  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/cloud-init/templates/${var.service}.yml.tpl", {
      instance_fqdn = "${var.service}.${var.environment}.${data.aws_route53_zone.selected.name}"
    })
  }

}

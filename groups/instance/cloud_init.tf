data "cloudinit_config" "artifactory" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = "#cloud-config"
  }

  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/cloud-init/templates/system.yml.tpl", {
    })
  }

  part {
    content_type = "text/cloud-config"
    content      = templatefile("${path.module}/cloud-init/templates/bootstrap-commands.yml.tpl", {
    })
  }

}

data "cloudinit_config" "artifactory" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = "#cloud-config"
  }

#  part {
#    content_type = "text/cloud-config"
#    content = templatefile("${path.module}/cloud-init/templates/system.yml.tpl", {
#      db_fqdn     = local.db_fqdn
#      db_username = local.db_username
#      db_password = local.db_password
#
#    })
#  }

  part {
    content_type   = "text/cloud-config"
    content        = templatefile("${path.module}/cloud-init/templates/bootstrap-commands.yml.tpl", {
      access_token = local.artifactory_access_token
    })
  }

}

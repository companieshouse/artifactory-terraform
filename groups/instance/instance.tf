resource "aws_key_pair" "artifactory" {
  key_name   = local.ssh_keyname
  public_key = local.ssh_public_key
}

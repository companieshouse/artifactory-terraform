resource "aws_key_pair" "artifactory" {
  key_name   = local.base_path
  public_key = local.ssh_public_key
}

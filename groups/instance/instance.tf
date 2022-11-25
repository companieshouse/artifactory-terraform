resource "aws_instance" "artifactory" {
  ami           = var.ami
  instance_type = var.default_instance_type
  subnet_id = local.placement_vpc_pattern
}

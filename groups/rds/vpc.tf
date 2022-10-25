data "aws_region" "current" {}

resource "aws_vpc_ipam" "main" {
  operating_regions {
    region_name = data.aws_region.current.name
  }
}

resource "aws_vpc_ipam_pool" "main" {
  address_family = "ipv4"
  ipam_scope_id  = aws_vpc_ipam.main.private_default_scope_id
  locale         = data.aws_region.current.name
}

data "aws_vpc" "all_vpc_id" {
  for_each = data.aws_vpc.all_vpc_id[*].id
  id = each.value
}

data "aws_subnet" "placement" {
  for_each = data.aws_subnet_ids.placement.ids
  id = each.value
}

data "aws_subnet_ids" "placement" {
  vpc_id = data.aws_vpc.placement.id

  filter {
    name   = "tag:Name"
    values = [local.placement_subnet_pattern]
  }
}
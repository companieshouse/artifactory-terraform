data "aws_region" "current" {}

data "aws_subnet_ids" "placement" {
  vpc_id = data.aws_vpc.placement.id

  filter {
    name   = "tag:Name"
    values = [local.placement_subnet_pattern]
  }
}

data "aws_subnet" "placement" {
  for_each = data.aws_subnet_ids.placement.ids
  id       = each.value
}

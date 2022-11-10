output vpc_ids {
  value = data.aws_vpc.placement.id
}

output subnet_ids {
  value = local.placement_subnet_ids
}

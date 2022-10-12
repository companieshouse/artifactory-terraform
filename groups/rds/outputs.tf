output vpc_ids {
  value = data.aws_vpc.all_vpc_id
}

output subnet_ids {
  value = data.aws_subnet.placement
}
output instance_ip {
  value = aws_instance.artifactory.private_ip
}

output dns_hostname {
  value = aws_route53_record.instance.fqdn
}
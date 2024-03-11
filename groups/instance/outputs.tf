output dns_hostname {
  value = aws_route53_record.instance.fqdn
}

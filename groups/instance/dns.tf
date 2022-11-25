resource "aws_route53_record" "instance" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "${var.service}.${var.environment}.${data.aws_route53_zone.selected.name}."
  type    = "A"
  ttl     = 300
  records = [aws_instance.artifactory.private_ip]
}


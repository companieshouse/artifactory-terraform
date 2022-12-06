resource "aws_route53_record" "db" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "${var.service}db.${data.aws_route53_zone.selected.name}."
  type    = "CNAME"
  ttl     = 300
  records = [aws_db_instance.db.address]
}

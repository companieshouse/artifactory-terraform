resource "aws_route53_record" "instance" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "${var.service}-${var.environment}.${data.aws_route53_zone.selected.name}"
  type    = "A"
  alias {
    name                   = aws_lb.artifactory.dns_name
    zone_id                = aws_lb.artifactory.zone_id
    evaluate_target_health = false
  }
}


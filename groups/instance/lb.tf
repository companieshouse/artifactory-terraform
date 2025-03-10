resource "aws_lb" "artifactory" {
  name                       = "${local.resource_prefix}-lb"
  internal                   = true
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.alb.id]
  subnets                    = local.automation_subnet_ids
  enable_deletion_protection = true

  tags = {
    Name = "${local.resource_prefix}-lb"
  }
}

resource "aws_lb_target_group" "front_end_8082" {
  name                 = "${local.resource_prefix}-tg-8082"
  deregistration_delay = var.alb_deregistration_delay
  port                 = 8082
  protocol             = "HTTP"
  vpc_id               = data.aws_vpc.placement.id

  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    port                = "8082"
    timeout             = 3
    healthy_threshold   = 3
    unhealthy_threshold = 3
    protocol            = "HTTP"
    matcher             = "200"
  }
}

resource "aws_acm_certificate" "certificate" {
  count = local.create_ssl_certificate ? 1 : 0

  domain_name               = "${local.resource_prefix}.${data.aws_route53_zone.selected.name}"
  subject_alternative_names = ["*.${local.resource_prefix}.${data.aws_route53_zone.selected.name}"]
  validation_method         = "DNS"
}

resource "aws_route53_record" "certificate_validation" {
  for_each = local.create_ssl_certificate ? {
    for dvo in aws_acm_certificate.certificate[0].domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  } : {}

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.selected.id
}

resource "aws_acm_certificate_validation" "certificate" {
  count = local.create_ssl_certificate ? 1 : 0

  certificate_arn         = aws_acm_certificate.certificate[0].arn
  validation_record_fqdns = [for record in aws_route53_record.certificate_validation : record.fqdn]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.artifactory.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.artifactory.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = local.ssl_certificate_arn
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.front_end_8082.arn
  }
}

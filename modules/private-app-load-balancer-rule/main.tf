
resource "aws_acm_certificate" "cert" {
  domain_name       = var.dns_domain
  validation_method = "DNS"
}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.this.zone_id
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}

data "aws_route53_zone" "this" {
  name         = var.base_dns_name
  private_zone = false
}

resource "aws_route53_record" "this" {
  zone_id = data.aws_route53_zone.this.id
  name    = var.dns_domain
  type    = "A"

  alias {
    name                   = var.public_nlb_dns_name
    zone_id                = var.public_nlb_zone_id
    evaluate_target_health = true
  }
}


resource "aws_lb_listener_certificate" "this" {
  listener_arn    = var.private_alb_arn
  certificate_arn = aws_acm_certificate.cert.arn

  depends_on = [
    aws_acm_certificate.cert,
    aws_acm_certificate_validation.cert,
    aws_route53_record.cert_validation
  ]
}


resource "aws_lb_target_group" "this" {
  target_type          = "ip"
  port                 = var.target_port
  protocol             = "HTTPS"
  vpc_id               = var.account_vpc_id
  name_prefix          = "${var.two_char_prefix}${substr(var.env, -4, 4)}"
  deregistration_delay = 60

  lifecycle {
    create_before_destroy = true
  }

  health_check {
    protocol            = "HTTPS"
    interval            = 10
    healthy_threshold   = 2
    unhealthy_threshold = 2
    path                = var.target_healthcheck_path
  }

  tags = {
    TargetGroupName = "${var.app_name}-${var.env}-private"
  }
}

resource "aws_lb_listener_rule" "this" {
  listener_arn = var.private_alb_arn
  priority     = index(var.envs, var.env) + 1

  action {
    order            = 1
    target_group_arn = aws_lb_target_group.this.arn
    type             = "forward"
  }

  condition {
    host_header {
      values = var.host_header_values
    }
  }
}


data "aws_vpc" "account_vpc" {
  id = var.account_vpc_id
}

resource "aws_lb" "this" {
  name    = "${var.app_name}-private-alb"
  subnets = var.public_subnet_ids

  security_groups = [aws_security_group.alb.id]

  internal = true

  enable_cross_zone_load_balancing = true
  drop_invalid_header_fields       = true

  load_balancer_type = "application"

  access_logs {
    enabled = true
    bucket  = var.alb_access_logs_bucket
    prefix  = "${var.app_name}-private-alb"
  }

  tags = {
    LoadBalancerName = "${var.app_name}-alb"
  }
}

resource "aws_security_group" "alb" {
  vpc_id      = var.account_vpc_id
  name        = "${var.app_name}-alb"
  description = "${var.app_name}-alb"

  tags = {
    Name   = "${var.app_name}-alb"
    source = "terraform"
  }
}

resource "aws_security_group_rule" "alb_from_vpc" {
  description       = "${var.app_name} alb in from vpc"
  type              = "ingress"
  from_port         = var.traffic_port
  to_port           = var.traffic_port
  protocol          = "TCP"
  security_group_id = aws_security_group.alb.id
  cidr_blocks       = [data.aws_vpc.account_vpc.cidr_block]
}

resource "aws_security_group_rule" "alb_from_anywhere" {
  # Traffic doesn't make it through to the ALB (even with no WAF) without allowing all
  # most likely because the client ip address is being passed through
  description       = "${var.app_name} alb in from anywhere"
  type              = "ingress"
  from_port         = var.traffic_port
  to_port           = var.traffic_port
  protocol          = "TCP"
  security_group_id = aws_security_group.alb.id
  cidr_blocks       = ["0.0.0.0/0"]
}

# A certificate must be specified for a HTTPS listener
# We return a 404 status code as there's nothing here to be hit
# The "env" stacks will add their actual listener rules as appropriate.
resource "aws_alb_listener" "this" {

  load_balancer_arn = aws_lb.this.arn
  port              = var.traffic_port
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
  certificate_arn   = var.dummy_certificate_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "not found"
      status_code  = "404"
    }
  }

  tags = {
    Name = "${var.app_name}-private-alb-default-404"
  }
}

resource "aws_lb_listener_rule" "this" {
  listener_arn = aws_alb_listener.this.arn
  priority     = 999

  action {
    order = 1
    type  = "fixed-response"
    # Return a 200 for healthchecks from the NLB
    fixed_response {
      content_type = "text/plain"
      message_body = "healthy"
      status_code  = "200"
    }
  }

  condition {
    source_ip {
      values = [data.aws_vpc.account_vpc.cidr_block]
    }
  }

  condition {
    path_pattern {
      values = [var.alb_healthcheck_path]
    }
  }

  tags = {
    Name = "${var.app_name}-private-alb-health-200"
  }
}

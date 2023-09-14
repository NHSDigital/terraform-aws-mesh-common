resource "aws_lb" "this" {
  name     = "${var.app_name}-public-nlb"
  internal = false

  enable_cross_zone_load_balancing = true
  load_balancer_type               = "network"

  access_logs {
    enabled = true
    bucket  = var.access_logs_bucket
    prefix  = "${var.app_name}-public-nlb"
  }

  # Bind the elastic ips to the network load balancer
  dynamic "subnet_mapping" {
    for_each = zipmap(var.public_subnet_ids, data.aws_eips.this.allocation_ids)
    content {
      subnet_id     = subnet_mapping.key
      allocation_id = subnet_mapping.value
    }
  }

  enable_deletion_protection = var.enable_deletion_protection

  tags = {
    LoadBalancerName = "${var.app_name}-public-nlb"
  }
}

resource "aws_lb_listener" "this" {
  default_action {
    target_group_arn = aws_lb_target_group.this.arn
    type             = "forward"
  }
  load_balancer_arn = aws_lb.this.arn
  port              = var.traffic_port
  protocol          = "TCP"

  depends_on = [
    aws_lb_target_group.this
  ]

  tags = {
    Name = "${var.app_name}-public-nlb"
  }
}

resource "aws_lb_target_group" "this" {
  target_type = "alb"
  port        = var.traffic_port
  protocol    = "TCP"
  vpc_id      = var.account_vpc_id
  name_prefix = "${var.two_char_prefix}${substr(var.account, 0, 4)}"

  preserve_client_ip = "true"

  lifecycle {
    create_before_destroy = true
  }

  health_check {
    protocol            = "HTTPS"
    interval            = 10
    healthy_threshold   = 2
    unhealthy_threshold = 2
    path                = var.alb_healthcheck_path
  }

  tags = {
    LoadBalancerName = aws_lb.this.name
    TargetGroupName  = "${var.app_name}-public"
  }

}

data "aws_eips" "this" {
  filter {
    name   = "tag:Name"
    values = ["${var.app_name}-*"]
  }
}

resource "aws_wafv2_ip_set" "blocklist_ipv4" {
  name               = "${var.app_name}-blocklist-ipv4"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses          = var.blocked_ipv4_cidrs

  tags = {
    Name = "${var.app_name}-blocklist-ipv4"
  }
}

resource "aws_wafv2_ip_set" "blocklist_ipv6" {
  name               = "${var.app_name}-blocklist-ipv6"
  scope              = "REGIONAL"
  ip_address_version = "IPV6"
  addresses          = var.blocked_ipv6_cidrs

  tags = {
    Name = "${var.app_name}-blocklist-ipv6"
  }
}

resource "aws_wafv2_ip_set" "allowlist_ipv4" {
  name               = "${var.app_name}-allowlist-ipv4"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses          = var.allowed_ipv4_cidrs

  tags = {
    Name = "${var.app_name}-allowlist-ipv4"
  }
}

resource "aws_wafv2_ip_set" "allowlist_vpc" {
  name               = "${var.app_name}-allowlist-vpc"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses          = [var.vpc_cidr]

  tags = {
    Name = "${var.app_name}-allowlist-vpc"
  }
}

resource "aws_wafv2_ip_set" "allowlist_ipv6" {
  name               = "${var.app_name}-allowlist-ipv6"
  scope              = "REGIONAL"
  ip_address_version = "IPV6"
  addresses          = var.allowed_ipv6_cidrs

  tags = {
    Name = "${var.app_name}-allowlist-ipv6"
  }
}

resource "aws_wafv2_ip_set" "rate_unlimited_ipv4" {
  name               = "${var.app_name}-rate-unlimited-ipv4"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses          = var.unlimited_ip_rate_limit_ipv4_cidrs

  tags = {
    Name = "${var.app_name}-rate-unlimited-ipv4"
  }
}

resource "aws_wafv2_ip_set" "rate_unlimited_ipv6" {
  name               = "${var.app_name}-rate-unlimited-ipv6"
  scope              = "REGIONAL"
  ip_address_version = "IPV6"
  addresses          = var.unlimited_ip_rate_limit_ipv6_cidrs

  tags = {
    Name = "${var.app_name}-rate-unlimited-ipv6"
  }
}

resource "aws_wafv2_ip_set" "specified_rate_limit_ipv4" {
  for_each = var.specified_ip_rate_limit_ipv4_cidrs

  name               = "${var.app_name}-rate-limited-ipv4-${each.key}"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses          = each.value.cidrs

  tags = {
    Name = "${var.app_name}-rate-limited-ipv4-${each.key}"
  }
}

resource "aws_wafv2_ip_set" "specified_rate_limit_ipv4_all" {
  name               = "${var.app_name}-rate-limited-ipv4_all"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses          = flatten([for k, v in var.specified_ip_rate_limit_ipv4_cidrs : v.cidrs])

  tags = {
    Name = "${var.app_name}-rate-limited-ipv4_all"
  }
}

resource "aws_wafv2_ip_set" "specified_rate_limit_ipv6" {
  for_each = var.specified_ip_rate_limit_ipv6_cidrs

  name               = "${var.app_name}-rate-limited-ipv6-${each.key}"
  scope              = "REGIONAL"
  ip_address_version = "IPV6"
  addresses          = each.value.cidrs

  tags = {
    Name = "${var.app_name}-rate-limited-ipv6-${each.key}"
  }
}

resource "aws_wafv2_ip_set" "specified_rate_limit_ipv6_all" {
  name               = "${var.app_name}-rate-limited-ipv6_all"
  scope              = "REGIONAL"
  ip_address_version = "IPV6"
  addresses          = flatten([for k, v in var.specified_ip_rate_limit_ipv6_cidrs : v.cidrs])

  tags = {
    Name = "${var.app_name}-rate-limited-ipv6_all"
  }
}

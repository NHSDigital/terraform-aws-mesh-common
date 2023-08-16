resource "aws_wafv2_ip_set" "blocklist_ipv4" {
  name               = "blocklist-ipv4"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses          = var.blocked_ipv4_cidrs

  tags = {
    Name = "${var.app_name}-blocklist-ipv4"
  }
}

resource "aws_wafv2_ip_set" "blocklist_ipv6" {
  name               = "blocklist-ipv6"
  scope              = "REGIONAL"
  ip_address_version = "IPV6"
  addresses          = var.blocked_ipv6_cidrs

  tags = {
    Name = "${var.app_name}-blocklist-ipv6"
  }
}

resource "aws_wafv2_ip_set" "allowlist_ipv4" {
  name               = "allowlist-ipv4"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses          = var.allowed_ipv4_cidrs

  tags = {
    Name = "${var.app_name}-allowlist-ipv4"
  }
}

resource "aws_wafv2_ip_set" "allowlist_vpc" {
  name               = "allowlist-vpc"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses          = [var.vpc_cidr]

  tags = {
    Name = "${var.app_name}-allowlist-vpc"
  }
}

resource "aws_wafv2_ip_set" "allowlist_ipv6" {
  name               = "allowlist-ipv6"
  scope              = "REGIONAL"
  ip_address_version = "IPV6"
  addresses          = var.allowed_ipv6_cidrs

  tags = {
    Name = "${var.app_name}-allowlist-ipv6"
  }
}

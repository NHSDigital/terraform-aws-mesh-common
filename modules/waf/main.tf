# IP preservation
# https://docs.aws.amazon.com/elasticloadbalancing/latest/network/load-balancer-target-groups.html#client-ip-preservation:~:text=When%20you%20specify,to%20the%20target.
#
resource "aws_wafv2_web_acl" "waf_web_acl" {
  name        = "${var.app_name}-web-acl"
  description = "Only allow traffic from country list with additional allow and block lists"
  scope       = "REGIONAL"

  default_action {
    block {}
  }

  rule {
    # we can remove this comment, but i just wanted to raise it for code review:
    # the first 2 rules have priority 1/2 and there is short-circuit evaluation,
    # so it will allow these IPs/VPCs REGARDLESS of all other rules,
    # e.g. anything in the allowlist is implicitly rate unlimited
    name     = "IPAllowList"
    priority = 1

    action {
      allow {}
    }

    statement {
      or_statement {
        statement {
          ip_set_reference_statement {
            arn = aws_wafv2_ip_set.allowlist_ipv4.arn
          }
        }
        statement {
          ip_set_reference_statement {
            arn = aws_wafv2_ip_set.allowlist_ipv6.arn
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "IPAllowList"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "VPCAllowList"
    priority = 2

    action {
      allow {}
    }

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.allowlist_vpc.arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "VPCAllowList"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "IPBlockList"
    priority = 3

    action {
      block {}
    }

    statement {
      or_statement {
        statement {
          ip_set_reference_statement {
            arn = aws_wafv2_ip_set.blocklist_ipv4.arn
          }
        }
        statement {
          ip_set_reference_statement {
            arn = aws_wafv2_ip_set.blocklist_ipv6.arn
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "IPBlockList"
      sampled_requests_enabled   = true
    }
  }

  dynamic "rule" {
    for_each = var.managed_rules
    content {
      override_action {
        count {}
      }
      name     = rule.value
      priority = 10
      statement {
        managed_rule_group_statement {
          name        = rule.value
          vendor_name = "AWS"
        }
      }
      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = rule.value
        sampled_requests_enabled   = true
      }
    }
  }

  rule {
    name     = "IPRateLimit_default"
    priority = 20

    action {
      block {
        custom_response {
          response_code = 429
        }
      }
    }

    statement {
      rate_based_statement {
        aggregate_key_type = "IP"
        limit              = var.default_ip_rate_limit

        scope_down_statement {
          not_statement {
            statement {
              or_statement {
                statement {
                  ip_set_reference_statement {
                    arn = aws_wafv2_ip_set.specified_rate_limit_ipv4_all.arn
                  }
                }
                statement {
                  ip_set_reference_statement {
                    arn = aws_wafv2_ip_set.specified_rate_limit_ipv6_all.arn
                  }
                }
                statement {
                  ip_set_reference_statement {
                    arn = aws_wafv2_ip_set.rate_unlimited_ipv4.arn
                  }
                }
                statement {
                  ip_set_reference_statement {
                    arn = aws_wafv2_ip_set.rate_unlimited_ipv6.arn
                  }
                }
              }
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "IPRateLimit_default"
      sampled_requests_enabled   = true
    }
  }

  dynamic "rule" {
    for_each = var.specified_ip_rate_limit_ipv4_cidrs
    content {
      name     = "IPRateLimit_${rule.key}"
      priority = 21

      action {
        block {
          custom_response {
            response_code = 429
          }
        }
      }

      statement {
        rate_based_statement {
          aggregate_key_type = "IP"
          limit              = rule.value[1]

          scope_down_statement {
            ip_set_reference_statement {
              arn = aws_wafv2_ip_set.specified_rate_limit_ipv4[rule.key].arn
            }
          }
        }
      }
      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = rule.key
        sampled_requests_enabled   = true
      }
    }
  }

  dynamic "rule" {
    for_each = var.specified_ip_rate_limit_ipv6_cidrs
    content {
      name     = "IPRateLimit_${rule.key}"
      priority = 22

      action {
        block {
          custom_response {
            response_code = 429
          }
        }
      }

      statement {
        rate_based_statement {
          aggregate_key_type = "IP"
          limit              = rule.value[1]

          scope_down_statement {
            ip_set_reference_statement {
              arn = aws_wafv2_ip_set.specified_rate_limit_ipv6[rule.key].arn
            }
          }
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = rule.key
        sampled_requests_enabled   = true
      }
    }
  }

  rule {
    name     = "CountryAllowList"
    priority = 99

    statement {
      geo_match_statement {
        country_codes = var.allowed_country_codes
      }
    }

    action {
      allow {}
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "CountryAllowList"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "Unmatched"
    sampled_requests_enabled   = true
  }

  tags = {
    Name = "${var.app_name}-web-acl"
  }
}

# Associate the WebACL with the ALB
resource "aws_wafv2_web_acl_association" "waf_alb_association" {
  resource_arn = var.alb_arn
  web_acl_arn  = aws_wafv2_web_acl.waf_web_acl.arn
}

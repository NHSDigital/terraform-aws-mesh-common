resource "aws_shield_protection" "this" {
  for_each     = var.arns_to_protect
  name         = each.key
  resource_arn = each.value

  tags = {
    Name = "${var.app_name}-${each.key}"
  }
}

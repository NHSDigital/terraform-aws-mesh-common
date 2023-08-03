
resource "aws_security_group" "lambda" {
  vpc_id      = var.vpc_id
  name        = var.name
  description = var.name

  tags = {
    Name   = var.name
    source = "terraform"
  }
}

# tflint-ignore: terraform_naming_convention
resource "aws_security_group_rule" "lambda-to-logs" {
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.lambda.id
  description              = "to logs"
  source_security_group_id = var.logs_vpc_endpoint_sg_id
}

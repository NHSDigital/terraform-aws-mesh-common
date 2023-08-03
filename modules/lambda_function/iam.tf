
resource "aws_iam_role" "lambda" {
  name = var.name
  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17",
      Statement = [
        {
          Action = "sts:AssumeRole",
          Principal = {
            Service = "lambda.amazonaws.com"
          },
          Effect = "Allow"
        }
      ]
    }
  )
}

data "aws_iam_policy_document" "lambda" {

  source_policy_documents = var.role_json == null ? [] : [var.role_json]

  statement {
    effect        = "Allow"
    not_actions   = []
    not_resources = []
    actions = [
      "logs:PutLogEvents",
      "logs:CreateLogStream"
    ]
    resources = [
      aws_cloudwatch_log_group.lambda.arn
    ]
  }

}

resource "aws_iam_role_policy" "lambda" {
  name = var.name
  role = aws_iam_role.lambda.id

  policy = data.aws_iam_policy_document.lambda.json
}

# tflint-ignore: terraform_naming_convention
resource "aws_iam_role_policy_attachment" "vpc-execution-policy-attachment" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

# tflint-ignore: terraform_naming_convention
resource "aws_iam_role_policy_attachment" "lambda-insights" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLambdaInsightsExecutionRolePolicy"
}

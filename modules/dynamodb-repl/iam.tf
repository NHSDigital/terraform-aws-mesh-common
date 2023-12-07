module "iam" {
  source = "../iam_actions"
}

data "aws_iam_policy_document" "this" {

  statement {
    effect        = "Allow"
    not_actions   = []
    not_resources = []
    actions       = module.iam.iam_actions.iam_dynamodb_read_stream_actions
    resources = [
      local.source_table_arn,
      "${local.source_table_arn}/stream/*"
    ]
  }

  statement {
    effect        = "Allow"
    not_actions   = []
    not_resources = []
    actions       = module.iam.iam_actions.iam_kms_decrypt_actions
    resources     = [var.source_table_kms_arn]
  }

  statement {
    effect        = "Allow"
    not_actions   = []
    not_resources = []
    actions       = module.iam.iam_actions.iam_kms_encrypt_decrypt_actions
    resources = [
      var.target_table_kms_arn,
    ]
  }

  statement {
    effect        = "Allow"
    not_actions   = []
    not_resources = []
    actions       = module.iam.iam_actions.iam_dynamodb_read_write_access
    resources = [
      local.target_table_arn,
      "${local.target_table_arn}/*"
    ]
  }
}

resource "aws_iam_policy" "this" {
  name   = "${var.lambda_function_name}-ddb-repl"
  policy = data.aws_iam_policy_document.this.json
}

resource "aws_iam_role_policy_attachment" "this" {
  policy_arn = aws_iam_policy.this.arn
  role       = var.lambda_role_name
}

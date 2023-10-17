module "iam_actions" {
  source = "../iam_actions"
}

data "aws_iam_policy_document" "lambda_jwks_rotate_policy" {

  statement {
    actions = module.iam_actions.iam_actions.iam_kms_encrypt_decrypt_actions
    resources = [
      var.jwks_certs_secrets_kms_key_arn,
      var.jwks_json_s3_kms_arn,
    ]
  }

  statement {
    actions = concat(
      module.iam_actions.iam_actions.iam_secretsmanager_create_actions,
      module.iam_actions.iam_actions.iam_secretsmanager_put_actions,
      module.iam_actions.iam_actions.iam_secretsmanager_delete_actions
    )
    resources = [
      "${var.base_secrets_arn}:${var.jwks_certs_secrets_id_prefix}/*"
    ]
  }

  statement {
    actions = concat(
      module.iam_actions.iam_actions.iam_s3_list_bucket_actions,
      module.iam_actions.iam_actions.iam_s3_read_write_actions
    )
    resources = [
      var.jwks_json_s3_bucket_arn,
      "${var.jwks_json_s3_bucket_arn}/${var.jwks_json_s3_key}"
    ]
  }

  statement {
    actions = module.iam_actions.iam_actions.iam_ssm_get_put_parameter_actions
    resources = [
      "${var.base_ssm_parameter_arn}/${var.jwks_current_kid_ssm_name}"
    ]
  }

}

module "lambda_function" {
  source  = "../lambda_function"
  account = var.account
  region  = var.region

  name      = "${var.env}-${var.name}"
  file_path = var.file_path
  role_json = data.aws_iam_policy_document.lambda_jwks_rotate_policy.json

  subnet_ids              = var.subnet_ids
  vpc_id                  = var.vpc_id
  logs_vpc_endpoint_sg_id = var.logs_vpc_endpoint_sg_id

  environment = merge(
    merge(
      {
        MESH_ENV                      = var.env
        JWKS_JSON_S3_BUCKET_NAME      = var.jwks_json_s3_bucket_name
        JWKS_JSON_S3_KEY              = var.jwks_json_s3_key
        JWKS_CERTS_SECRETS_KMS_KEY_ID = var.jwks_certs_secrets_kms_key_id
        JWKS_CERTS_SECRETS_ID_PREFIX  = var.jwks_certs_secrets_id_prefix
        JWKS_CURRENT_KID_SSM_NAME     = var.jwks_current_kid_ssm_name
        JWKS_MIN_KEYS_RETAINED        = var.jwks_min_keys_retained
        JWKS_MIN_DAYS_RETAINED        = var.jwks_min_days_retained
      },
      var.boto_env_vars
    )
  )

  runtime           = var.lambda_runtime
  layers            = var.lambda_layers
  alarm_actions     = var.lambda_alarm_actions
  alarm_description = var.lambda_alarm_description
  timeout           = var.lambda_timeout
  memory_size       = var.lambda_memory_size
}

resource "aws_cloudwatch_event_rule" "schedule" {
  name                = module.lambda_function.name
  description         = "trigger ${module.lambda_function.name}"
  schedule_expression = var.jwks_schedule_expression
}

resource "aws_lambda_permission" "allow_events_bridge_to_run_lambda" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_function.name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.schedule.arn
}

resource "aws_security_group_rule" "lambda_jwks_rotate_to_s3" {
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = module.lambda_function.sg_id
  description       = "to s3"
  prefix_list_ids = [
    var.s3_gateway_prefix_list_ids
  ]
}

resource "aws_security_group_rule" "lambda_jwks_rotate_to_secretsmanager" {
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = module.lambda_function.sg_id
  description              = "to secretsmanager"
  source_security_group_id = var.secrets_manager_interface_endpoint_sg_ids
}

resource "aws_security_group_rule" "lambda_jwks_rotate_to_ssm" {
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = module.lambda_function.sg_id
  description              = "to ssm"
  source_security_group_id = var.ssm_interface_endpoint_sg_ids
}

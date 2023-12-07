
resource "aws_lambda_event_source_mapping" "this" {
  event_source_arn  = data.aws_dynamodb_table.source.stream_arn
  function_name     = var.lambda_function_name
  starting_position = var.event_source_mapping_starting_position
  enabled           = var.event_source_mapping_enabled

  batch_size                         = var.event_source_mapping_batch_size
  bisect_batch_on_function_error     = var.event_source_mapping_bisect
  parallelization_factor             = var.event_source_mapping_parallelization_factor
  maximum_batching_window_in_seconds = var.event_source_mapping_max_batch_window_secs
}

resource "aws_security_group_rule" "to_ddb" {
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = var.lambda_sg_id
  description       = "to ddb"
  prefix_list_ids = [
    var.dynamodb_gateway_prefix_list_ids
  ]
}

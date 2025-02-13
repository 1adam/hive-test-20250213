# CloudWatch Logs Group to contain webserver logs

resource "aws_cloudwatch_log_group" "webserver" {
  name = "/fargate/service/${var.namespace}-${var.environment}"

  retention_in_days = 14

  tags = merge(
    local.global_tags, {
      Name = "${var.namespace}-${var.environment}"
    }
  )
}

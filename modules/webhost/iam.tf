# IAM definitions for the 'webserver' ecs service

# IAM role for the webserver ECS task
resource "aws_iam_role" "webserver_ecs_task" {
  name               = "${var.namespace}-${var.environment}-task"
  assume_role_policy = data.aws_iam_policy_document.webserver_ecs_assume.json

  tags = merge(
    local.global_tags,
    { Name = "${var.namespace}-${var.environment}-ecs-task-exec" }
  )
}

data "aws_iam_policy_document" "webserver_ecs_assume" {
  statement {
    sid    = "AmazonECSTaskExecution${var.namespace}"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
    actions = [
      "sts:AssumeRole"
    ]
  }
}

# Allow the task to write to CloudWatch Logs
data "aws_iam_policy_document" "webserver_ecs_task" {
  statement {
    sid    = "CloudWatchLogsWebserver"
    effect = "Allow"
    resources = [
      "arn:aws:logs:*:*:*"
    ]
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams"
    ]
  }
}

resource "aws_iam_policy" "webserver_ecs_task" {
  name        = "${var.namespace}-${var.environment}-ecs-task"
  path        = "/"
  description = "Policy for the webserver ECS to access CloudWatch Logs"
  policy      = data.aws_iam_policy_document.webserver_ecs_task.json
}

resource "aws_iam_role_policy_attachment" "webserver_ecs_task" {
  role       = aws_iam_role.webserver_ecs_task.name
  policy_arn = aws_iam_policy.webserver_ecs_task.arn
}

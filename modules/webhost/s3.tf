###
### Resources for VPC flow logs
###
# OMITTED due to time constraints
#resource "aws_s3_bucket" "vpc_flow_logs" {
#  bucket = "vpc-flow-logs-${var.environment}"
#  count  = var.environment == "prod" ? 1 : 0
#
#  tags = merge(
#    local.global_tags,
#    {
#      Name = "vpc-flow-logs-${var.environment}"
#    }
#  )
#}

###
### Resources for Load Balancer access logs
###
resource "aws_s3_bucket" "lb_logs" {
  bucket = "${var.namespace}-${var.environment}-lb-logs"
}

data "aws_iam_policy_document" "allow_lb_logging" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [data.aws_elb_service_account.main.arn]
    }

    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.lb_logs.arn}/*"]
  }
}

resource "aws_s3_bucket_policy" "allow_lb_logging" {
  bucket = aws_s3_bucket.lb_logs.id
  policy = data.aws_iam_policy_document.allow_lb_logging.json
}

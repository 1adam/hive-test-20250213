# To determine what region we're operating in
data "aws_region" "current" {}

# To discover the AWS Account ID for Principal for the LB access_logs bucket
data "aws_elb_service_account" "main" {}

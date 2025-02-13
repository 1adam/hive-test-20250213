provider "aws" {
  region = var.aws_region
}

terraform {
  # we assume the backend is already defined elsewhere, as per the project requirements
  # backend "s3" { }
}

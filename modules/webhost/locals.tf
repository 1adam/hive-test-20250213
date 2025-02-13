# Tags that will be applied to all resources
locals {
  global_tags = {
    "environment" = var.environment
    "namespace"   = var.namespace
  }
}

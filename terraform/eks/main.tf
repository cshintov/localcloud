locals {
  required_tags = {
    project     = var.project,
    environment = var.environment
  }
  tags = merge(var.common_tags, local.required_tags)
}

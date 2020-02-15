terraform {
  required_version = ">= 0.12.1"

  required_providers {
    aws  = "~> 2.45"
    helm = "~> 1.0"
    null = "~> 2.1"
  }
}

module "label" {
  source      = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.16.0"
  namespace   = var.namespace
  stage       = var.stage
  environment = var.environment
  attributes  = var.attributes
  delimiter   = var.delimiter
  tags        = var.tags
  name        = var.name
}

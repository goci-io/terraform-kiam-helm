terraform {
  required_version = ">= 0.12.1"

  required_providers {
    helm = "~> 1.0"
    null = "~> 2.1"
  }
}

provider "aws" {
  version = "~> 2.45"

  assume_role {
    role_arn = var.aws_assume_role_arn
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

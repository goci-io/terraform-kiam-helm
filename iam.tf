data "aws_caller_identity" "current" {}

locals {
  default_masters_role_arn = format("arn:aws:iam::%s:role/masters.%s.%s.%s.%s", local.aws_account_id, var.stage, var.region, var.namespace, var.cluster_tld)
  kiam_assume_prefix       = coalesce(var.assume_role_prefix, format("arn:aws:iam::%s:role/%s-*-pod-*", local.aws_account_id, var.namespace))
  iam_role_name            = var.iam_role_name_override == "" ? module.iam_label.id : var.iam_role_name_override
  aws_account_id           = coalesce(var.aws_account_id, data.aws_caller_identity.current.account_id)
  masters_role_arn         = coalesce(var.masters_role_arn, local.default_masters_role_arn)
  server_iam_role_arn      = coalesce(join("", aws_iam_role.kiam_server.*.arn), var.server_iam_role_arn)
  server_iam_role_id       = coalesce(join("", aws_iam_role.kiam_server.*.id), local.server_role_parts[length(local.server_role_parts) - 1])
  server_role_parts        = split("/", var.server_iam_role_arn)
}

module "iam_label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.16.0"
  context    = module.label.context
  attributes = [var.region]
}

data "aws_iam_policy_document" "kiam_server_trust" {
  count = var.server_iam_role_arn == "" ? 1 : 0

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [local.masters_role_arn]
    }
  }
}

resource "aws_iam_role" "kiam_server" {
  count              = var.server_iam_role_arn == "" ? 1 : 0
  name               = local.iam_role_name
  tags               = module.iam_label.tags
  assume_role_policy = join("", data.aws_iam_policy_document.kiam_server_trust.*.json)
}

data "aws_iam_policy_document" "kiam_server" {
  statement {
    effect    = "Allow"
    actions   = ["sts:AssumeRole"]
    resources = [local.kiam_assume_prefix]
  }
}

resource "aws_iam_role_policy" "server_policy" {
  role   = local.server_iam_role_id
  name   = module.iam_label.id
  policy = data.aws_iam_policy_document.kiam_server.json
}

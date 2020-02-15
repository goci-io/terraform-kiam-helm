data "aws_caller_identity" "current" {}

locals {
  default_masters_role_arn = format("arn:aws:iam::%s:role/masters.%s.%s.%s.%s")
  kiam_assume_prefix       = coalesce(var.assume_role_prefix, format("arn:aws:iam::%s:role/%s-pod-*", var.namespace))
  aws_account_id           = coalesce(var.aws_account_id, data.aws_caller_identity.current.account_id)
  masters_role_arn         = coalesce(var.masters_role_arn, local.default_masters_role_arn)
}

module "iam_label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.16.0"
  context    = module.label.context
  attributes = [var.region]
}

data "aws_iam_policy_document" "kiam_server_trust" {
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
  name               = module.iam_label.id
  tags               = module.iam_label.tags
  assume_role_policy = data.aws_iam_policy_document.kiam_server_trust.json
}

data "aws_iam_policy_document" "kiam_server" {
  statement {
    effect    = "Allow"
    actions   = ["sts:AssumeRole"]
    resources = [local.kiam_assume_prefix]
  }
}
resource "aws_iam_policy" "server_policy" {
  name        = module.iam_label.id
  policy      = data.aws_iam_policy_document.kiam_server.json
  description = "Policy for the Kiam Server process"
}

resource "aws_iam_policy_attachment" "server_policy_attach" {
  name       = module.iam_label.id
  roles      = [aws_iam_role.kiam_server.name]
  policy_arn = aws_iam_policy.server_policy.arn
}

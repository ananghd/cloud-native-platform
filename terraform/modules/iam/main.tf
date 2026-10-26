variable "name" { type = string }
variable "oidc_provider_arn" { type = string }
variable "oidc_provider_url" { type = string }
variable "namespace" { type = string, default = "app" }
variable "service_account" { type = string, default = "app" }
variable "policy_arns" { type = list(string), default = [] }

data "aws_iam_policy_document" "assume" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      type        = "Federated"
      identifiers = [var.oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.oidc_provider_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:${var.namespace}:${var.service_account}"]
    }
  }
}

resource "aws_iam_role" "this" {
  name               = "${var.name}-irsa"
  assume_role_policy = data.aws_iam_policy_document.assume.json
  tags               = { Name = "${var.name}-irsa" }
}

resource "aws_iam_role_policy_attachment" "attach" {
  count      = length(var.policy_arns)
  role       = aws_iam_role.this.name
  policy_arn = var.policy_arns[count.index]
}

output "role_arn" { value = aws_iam_role.this.arn }

locals {
  name = "${var.service_name}-iam-role"
}

resource "kubernetes_service_account" "this" {
  metadata {
    name      = local.service_account_name
    namespace = var.kubernetes_namespace

    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.this.arn
    }
  }

  automount_service_account_token = true
}


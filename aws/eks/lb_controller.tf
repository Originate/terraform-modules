# For information about AWS Load Balancer Controller see:
# https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller.html

data "http" "lb_controller_iam_policy_doc" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.1.2/docs/install/iam_policy.json"
}

data "http" "lb_controller_crd_manifest" {
  url = "https://raw.githubusercontent.com/aws/eks-charts/master/stable/aws-load-balancer-controller/crds/crds.yaml"
}

resource "aws_iam_role" "lb_controller" {
  name = "${var.stack}-${var.env}-alb-ingress"

  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Principal = {
            Federated = module.eks.oidc_provider_arn
          }
          Action = "sts:AssumeRoleWithWebIdentity"
          Condition = {
            StringEquals = {
              "${trimprefix(module.eks.cluster_oidc_issuer_url, "https://")}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller"
            }
          }
        }
      ]
    }
  )
}

resource "aws_iam_role_policy" "lb_controller" {
  name = "aws-load-balancer-controller-permissions"
  role = aws_iam_role.lb_controller.id

  policy = data.http.lb_controller_iam_policy_doc.body
}

resource "kubernetes_service_account" "lb_controller" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"

    labels = {
      "app.kubernetes.io/component" = "controller"
      "app.kubernetes.io/name"      = "aws-load-balancer-controller"
    }

    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.lb_controller.arn
    }
  }
}

resource "kubectl_manifest" "lb_controller_crd" {
  yaml_body = data.http.lb_controller_crd_manifest.body
}

resource "helm_release" "lb_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = var.aws_load_balancer_controller_version
  namespace  = "kube-system"

  set {
    name  = "clusterName"
    value = module.eks.cluster_id
  }

  set {
    name  = "serviceAccount.create"
    value = false
  }

  set {
    name  = "serviceAccount.name"
    value = kubernetes_service_account.lb_controller.metadata[0].name
  }
}

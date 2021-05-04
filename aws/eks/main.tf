locals {
  cluster_name = "${var.stack}-${var.env}-eks"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "15.1.0"

  cluster_name    = local.cluster_name
  cluster_version = var.kubernetes_version

  vpc_id  = var.vpc_id
  subnets = var.subnet_ids

  enable_irsa                  = true
  manage_aws_auth              = true
  manage_cluster_iam_resources = true
  manage_worker_iam_resources  = true
  write_kubeconfig             = false

  cluster_enabled_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]

  cluster_encryption_config = [
    {
      provider_key_arn = aws_kms_key.secrets.arn
      resources        = ["secrets"]
    }
  ]

  map_roles = [
    {
      rolearn  = aws_iam_role.admin.arn
      username = aws_iam_role.admin.arn
      groups   = ["system:masters"]
    }
  ]

  node_groups_defaults = {
    ami_type      = "AL2_x86_64"
    capacity_type = "ON_DEMAND"
  }

  node_groups = {
    primary = {
      desired_capacity = var.node_count_min
      max_capacity     = var.node_count_max
      min_capacity     = var.node_count_min

      instance_types = [var.node_instance_class]
      disk_size      = var.node_disk_size
    }
  }

  # Forces module.eks.aws_eks_cluster.this to have a dependency on the
  # time_sleep.wait_for_logs_to_flush resource
  cluster_delete_timeout = time_sleep.wait_for_logs_to_flush.triggers.cluster_delete_timeout
}

# The terraform-aws-eks module leaves behind a CloudWatch Log Group after
# destroy that also blocks recreating the module with the same name. The most
# likely cause is that after destroying the cluster, any remaining logs take a
# few minutes to flush, which recreates the Log Group even after it has been
# deleted:
#
# https://github.com/terraform-aws-modules/terraform-aws-eks/issues/920
#
# This hack creates a 5 minute delay after the cluster has been destroyed before
# allowing the CloudWatch Log Group to be deleted
resource "time_sleep" "wait_for_logs_to_flush" {
  destroy_duration = "5m"

  triggers = {
    # Forces a dependency on module.eks.aws_cloudwatch_log_group.this
    cloudwatch_log_group_name = module.eks.cloudwatch_log_group_name

    # Forces module.eks.aws_eks_cluster.this to have a dependency on this
    # resource
    cluster_delete_timeout = "15m"
  }
}

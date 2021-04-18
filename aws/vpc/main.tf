data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.78.0"

  name = "${var.stack}-${var.env}-vpc"

  enable_dns_hostnames = true
  enable_dns_support   = true

  azs                = slice(sort(data.aws_availability_zones.available.names), 0, var.az_count)
  cidr               = var.cidr
  public_subnets     = var.public_subnet_cidrs
  private_subnets    = var.private_subnet_cidrs
  database_subnets   = var.database_subnet_cidrs
  enable_nat_gateway = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }

  tags = var.default_tags
}

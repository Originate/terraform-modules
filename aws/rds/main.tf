locals {
  instance_name = "${var.attributes.stack}-${var.attributes.env}-${var.sql_database}"
}

resource "random_uuid" "final_snapshot" {}

resource "random_password" "username" {
  length  = 63
  number  = false
  special = false
}

resource "random_password" "password" {
  length           = 128
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "2.21.0"

  identifier = local.instance_name

  engine                      = "postgres"
  engine_version              = "12.5"
  family                      = "postgres12"
  major_engine_version        = "12"
  allow_major_version_upgrade = false
  auto_minor_version_upgrade  = true

  instance_class    = var.attributes.instance_class
  allocated_storage = var.attributes.allocated_storage
  storage_type      = "gp2"

  multi_az          = var.attributes.multi_az
  storage_encrypted = true

  name     = var.sql_database
  username = random_password.username.result
  password = random_password.password.result

  vpc_security_group_ids = [aws_security_group.rds.id]
  subnet_ids             = var.attributes.subnet_ids
  publicly_accessible    = false
  port                   = 5432

  parameters = [
    {
      name  = "rds.force_ssl"
      value = "1"
    }
  ]

  maintenance_window      = "Mon:00:00-Mon:03:00"
  backup_window           = "03:00-06:00"
  backup_retention_period = var.attributes.backup_retention_period
  apply_immediately       = true

  create_monitoring_role          = var.attributes.enable_enhanced_monitoring
  monitoring_role_name            = var.attributes.enable_enhanced_monitoring ? "${local.instance_name}-rds" : ""
  monitoring_interval             = var.attributes.enable_enhanced_monitoring ? 15 : 0
  enabled_cloudwatch_logs_exports = var.attributes.enable_enhanced_monitoring ? ["postgresql", "upgrade"] : []

  deletion_protection       = var.attributes.enable_delete_protection
  skip_final_snapshot       = var.attributes.skip_final_snapshot
  final_snapshot_identifier = "${local.instance_name}-finalsnapshot-${random_uuid.final_snapshot.result}"

  tags = var.attributes.default_tags
}

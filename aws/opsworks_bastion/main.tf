locals {
  name = "${var.stack}-${var.env}-bastion"
}

data "aws_region" "current" {}

resource "aws_opsworks_stack" "this" {
  name   = local.name
  region = data.aws_region.current.name

  vpc_id            = var.vpc_id
  default_subnet_id = var.subnet_id

  service_role_arn             = aws_iam_role.opsworks.arn
  default_instance_profile_arn = aws_iam_instance_profile.this.arn

  agent_version                 = "LATEST"
  default_os                    = "Amazon Linux 2"
  default_root_device_type      = "ebs"
  configuration_manager_name    = "Chef"
  configuration_manager_version = "12"
  manage_berkshelf              = false
  use_custom_cookbooks          = false
  use_opsworks_security_groups  = false

  # Wait for permissions to be set before creating the stack
  depends_on = [aws_iam_role_policy.opsworks]
}

resource "aws_opsworks_custom_layer" "this" {
  name       = local.name
  short_name = "bastion"
  stack_id   = aws_opsworks_stack.this.id

  custom_security_group_ids = concat(
    [aws_security_group.ssh.id],
    var.additional_security_group_ids
  )

  auto_assign_elastic_ips     = false
  auto_assign_public_ips      = true
  auto_healing                = true
  install_updates_on_boot     = true
  use_ebs_optimized_instances = true
}

resource "aws_opsworks_instance" "this" {
  stack_id = aws_opsworks_stack.this.id
  layer_ids = [
    aws_opsworks_custom_layer.this.id,
  ]

  instance_type       = "t3.nano"
  state               = "running"
  virtualization_type = "hvm"

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 8
    delete_on_termination = true
  }
}

locals {
  docker_context_path = "${path.module}/docker"
  docker_tag = md5(join("", [
    aws_ecr_repository.this.repository_url,
    tls_private_key.ssh.public_key_openssh,
    file("${local.docker_context_path}/Dockerfile"),
    file("${local.docker_context_path}/sshd_config")
  ]))
}

resource "aws_ecr_repository" "this" {
  name = "${var.stack}-${var.env}-bastion"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Terraform   = "true"
    Stack       = var.stack
    Environment = var.env
  }
}

resource "null_resource" "docker_push" {
  triggers = {
    docker_tag = local.docker_tag
  }

  provisioner "local-exec" {
    working_dir = local.docker_context_path
    command     = <<-EOT
      set -eu
      docker build --build-arg "SSH_PORT=${var.ssh_port}" --build-arg "SSH_PUB_KEY=${tls_private_key.ssh.public_key_openssh}" -t "${aws_ecr_repository.this.repository_url}:${local.docker_tag}" -t "${aws_ecr_repository.this.repository_url}:latest" .
      eval "$(aws ecr get-login --no-include-email --profile ${var.profile})"
      docker push "${aws_ecr_repository.this.repository_url}:${local.docker_tag}"
      docker push "${aws_ecr_repository.this.repository_url}:latest"
    EOT
  }
}

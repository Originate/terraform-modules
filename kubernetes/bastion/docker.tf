locals {
  docker_context_path = "${path.module}/docker"
  docker_tag = md5(join("", [
    var.docker_repo,
    tls_private_key.ssh.public_key_openssh,
    file("${local.docker_context_path}/Dockerfile"),
    file("${local.docker_context_path}/sshd_config")
  ]))
}

resource "null_resource" "docker_push" {
  triggers = {
    docker_tag = local.docker_tag
  }

  provisioner "local-exec" {
    working_dir = local.docker_context_path
    command     = <<-EOT
      set -eu
      docker build --build-arg "SSH_PORT=${var.ssh_port}" --build-arg "SSH_PUB_KEY=${tls_private_key.ssh.public_key_openssh}" -t "${var.docker_repo}:${local.docker_tag}" -t "${var.docker_repo}:latest" .
      ${var.docker_login_command}
      docker push "${var.docker_repo}:${local.docker_tag}"
      docker push "${var.docker_repo}:latest"
    EOT
  }
}

locals {
  docker_context_path = "${path.module}/docker"
  docker_tag = md5(join("", [
    var.repo_url,
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
      docker build --build-arg "SSH_PORT=${var.ssh_port}" --build-arg "SSH_PUB_KEY=${tls_private_key.ssh.public_key_openssh}" -t "${var.repo_url}:${local.docker_tag}" -t "${var.repo_url}:latest" .
      ${var.docker_login_command}
      docker push "${var.repo_url}:${local.docker_tag}"
      docker push "${var.repo_url}:latest"
    EOT
  }
}

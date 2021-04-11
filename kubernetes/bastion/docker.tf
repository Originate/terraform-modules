locals {
  docker_context_path = "${path.module}/docker"
  docker_tag = md5(join("", [
    var.docker_repo,
    tls_private_key.ssh.public_key_openssh,
    file("${local.docker_context_path}/Dockerfile"),
    file("${local.docker_context_path}/sshd_config")
  ]))
}

module "docker_push" {
  source = "../../docker/push"

  repo = var.docker_repo
  tag  = local.docker_tag

  login_command = var.docker_login_command

  build_updated_images = true
  context_path         = local.docker_context_path
  build_args = {
    SSH_PORT    = var.ssh_port
    SSH_PUB_KEY = tls_private_key.ssh.public_key_openssh
  }
  additional_tags = ["latest"]
}

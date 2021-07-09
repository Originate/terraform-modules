resource "null_resource" "command" {
  triggers = {
    tag = var.tag
  }

  provisioner "local-exec" {
    working_dir = var.context_path
    command     = <<-EOT
      set -eu
      ${var.login_command}

      if ${var.build_updated_images}; then
        docker build %{for key, value in var.build_args}--build-arg "${key}=${value}" %{endfor}-f "${var.dockerfile_path}" -t "${var.repo}:${var.tag}" .
        docker push "${var.repo}:${var.tag}"
      else
        docker pull "${var.repo}:${var.tag}"
      fi

      %{for tag in var.additional_tags}
      docker tag "${var.repo}:${var.tag}" "${var.repo}:${tag}"
      docker push "${var.repo}:${tag}"
      %{endfor}
    EOT
  }
}

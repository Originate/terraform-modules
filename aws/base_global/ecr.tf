resource "aws_ecr_repository" "repo" {
  for_each = toset(var.repo_names)

  name = "${var.stack}/${each.key}"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Terraform   = "true"
    Stack       = var.stack
    Environment = var.env
  }
}

resource "aws_ecr_repository" "this" {
  name = "${var.stack}/${var.name}"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.default_tags
}

resource "aws_ecr_lifecycle_policy" "this" {
  count = var.keep_image_count == null ? 0 : 1

  repository = aws_ecr_repository.this.name

  policy = jsonencode(
    {
      rules = concat(
        [for i in range(length(var.preserve_image_tags)) :
          {
            rulePriority = i + 1
            description  = "Keep image tagged '${var.preserve_image_tags[i]}'"
            selection = {
              tagStatus     = "tagged"
              tagPrefixList = [var.preserve_image_tags[i]]
              countType     = "imageCountMoreThan"
              countNumber   = 1
            }
            action = {
              type = "expire"
            }
          }
        ],
        [
          {
            rulePriority = length(var.preserve_image_tags) + 1
            description  = "Keep last ${var.keep_image_count} images"
            selection = {
              tagStatus   = "any"
              countType   = "imageCountMoreThan"
              countNumber = var.keep_image_count
            }
            action = {
              type = "expire"
            }
          }
        ]
      )
    }
  )
}

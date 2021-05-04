module "ecr" {
  for_each = toset(var.ecr_repository_names)
  source   = "../ecr"

  stack = var.stack

  name                = each.key
  keep_image_count    = var.ecr_keep_image_count
  preserve_image_tags = var.ecr_preserve_image_tags
}

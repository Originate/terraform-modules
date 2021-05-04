variable "stack" {
  description = "The name of the stack"
  type        = string
}

variable "env" {
  description = "The name of the environment"
  type        = string
  default     = ""
}

variable "name" {
  description = "The name of this repository"
  type        = string
}

variable "keep_image_count" {
  description = "The number of the newest images to keep (older images are automatically pruned by ECR), or leave unset to disable pruning"
  type        = number
  default     = null
}

# ECR lifecycle policies are limited and can only match tags based on prefix
# rather than exact matches, leading this to potentially have some unintended
# side effects. This assumes that there are no other image tags with a prefix
# matching the provided tag name.
variable "preserve_image_tags" {
  description = "Ensures images with the matching Docker tags are kept when pruning old images"
  type        = list(string)
  default     = []
}

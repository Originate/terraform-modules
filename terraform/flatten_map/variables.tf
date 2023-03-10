variable "in" {
  description = "The map to flatten (will only flatten up to a depth of 20)"
  type        = any
}

variable "separator" {
  description = "Separator to use to separate map path segments"
  type        = string
  default     = "."
}

variable "fqdn" {
  description = "The FQDN of the website"
  type        = string
}

variable "source_dir" {
  description = "The path to the source content directory"
  type        = string
}

variable "index_document" {
  description = "The name of the index document for a directory on the website"
  type        = string
  default     = "index.html"
}

variable "error_document" {
  description = "The path of the error document for the website relative to the source_dir"
  type        = string
  default     = ""
}

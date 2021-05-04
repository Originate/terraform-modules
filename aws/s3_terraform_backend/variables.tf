variable "stack" {
  description = "The name of the stack, generally the project name"
  type        = string
}

variable "config_output_path" {
  description = "The path to save the backend configuration file, or leave empty to not write a configuration file"
  type        = string
  default     = ""
}

variable "profile" {
  description = "The profile to use for accessing the AWS account, used for the configuration file if written, or leave blank to exclude this field"
  type        = string
  default     = ""
}

variable "kms_key_deletion_window_in_days" {
  description = "Duration in days after which the KMS key is deleted after destruction of the resource"
  type        = number

  validation {
    condition     = var.kms_key_deletion_window_in_days >= 7 && var.kms_key_deletion_window_in_days <= 30
    error_message = "The kms_key_deletion_window_in_days value must be between 7 and 30 days, inclusive."
  }
}

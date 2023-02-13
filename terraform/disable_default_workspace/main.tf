resource "null_resource" "check" {
  lifecycle {
    precondition {
      condition     = terraform.workspace != "default"
      error_message = "Use of the \"default\" workspace is not allowed"
    }
  }
}

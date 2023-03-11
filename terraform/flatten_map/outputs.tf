output "out" {
  value = local.last.this

  precondition {
    condition     = local.last.next == {}
    error_message = "var.in has a depth greater than 20"
  }
}

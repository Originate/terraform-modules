locals {
  # This helps avoid queue names ending in "-" or "-.fifo"
  given_queue_name = var.identifier == "" ? "" : "-${var.identifier}"
  # All fifo queues must end in .fifo, per AWS rules
  queue_suffix    = var.is_fifo ? ".fifo" : ""
  full_queue_name = "${var.stack}-${var.env}${local.given_queue_name}${local.queue_suffix}"
}

resource "aws_sqs_queue" "this" {
  name                        = local.full_queue_name
  fifo_queue                  = var.is_fifo
  content_based_deduplication = var.is_fifo && var.content_based_deduplication
  receive_wait_time_seconds   = var.receive_wait_time_seconds
  visibility_timeout_seconds  = var.visibility_timeout_seconds
}

locals {
  # This helps avoid queue names ending in "-" or "-.fifo"
  given_queue_name = var.queue_name == "" ? "" : "-${var.queue_name}"
  # All fifo queues must end in .fifo, per AWS rules
  queue_suffix    = var.is_fifo == true ? ".fifo" : ""
  full_queue_name = "${var.stack}-${var.env}${local.given_queue_name}${local.queue_suffix}"
}

resource "aws_sqs_queue" "this" {
  name                        = local.full_queue_name
  fifo_queue                  = var.is_fifo
  content_based_deduplication = var.content_based_deduplication
  receive_wait_time_seconds   = var.receive_wait_time_seconds
  visibility_timeout_seconds  = var.visibility_timeout_seconds
}

resource "aws_sqs_queue_policy" "this" {
  queue_url = aws_sqs_queue.this.id

  policy = jsonencode(
    {
      Version : "2008-10-17"
      Id : "__default_policy_ID"
      Statement : [
        {
          Sid : "__owner_statement"
          Effect : "Allow"
          Principal : "*"
          Action : "sqs:*"
          Resource : "${aws_sqs_queue.this.arn}"
        }
      ]
    }
  )
}

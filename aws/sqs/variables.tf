variable "stack" {
  description = "The name of the stack"
  type        = string
}

variable "env" {
  description = "The name of the environment"
  type        = string
}

variable "identifier" {
  description = "The shorthand name of the queue. The full queue name can be retrieved as an output. Note that an empty string is still a valid queue name."
  type        = string
}

variable "visibility_timeout_seconds" {
  description = "The amount of time allowed to the processor to process a message before it is declared failed. Defaults to 30 seconds."
  type        = number
  default     = 30
}

variable "receive_wait_time_seconds" {
  description = "The time to wait when polling for new messages. Use 0 for immediate response. Longer values are preferred. Defaults to 20, which is the maximum."
  type        = number
  default     = 20
}

variable "is_fifo" {
  description = "Specifies if this queue should be a FIFO queue, which would preserve message ordering. Defaults to true."
  type        = bool
  default     = true
}

variable "content_based_deduplication" {
  description = "Specifies if this queue should use content-based deduplication. Defaults to true. Note: If is_fifo is not set to true, then this value is ignored."
  type        = bool
  default     = true
}

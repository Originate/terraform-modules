resource "aws_ecs_cluster" "this" {
  name = "${var.stack}-${var.env}-ecs"
}

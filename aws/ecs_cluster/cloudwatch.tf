resource "aws_cloudwatch_log_group" "this" {
  name = "${aws_ecs_cluster.this.name}-logs"

  tags = var.default_tags
}

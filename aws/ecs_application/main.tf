data "aws_region" "current" {}

resource "aws_ecs_task_definition" "this" {
  family = "${var.cluster_name}-${var.name}"

  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = var.task_execution_role_arn
  task_role_arn            = aws_iam_role.this.arn

  container_definitions = jsonencode(
    [
      merge(
        {
          name      = var.name
          image     = "${var.docker_repo}:${var.docker_tag}"
          essential = true

          portMappings = [
            {
              containerPort = var.container_port
              protocol      = "tcp"
            }
          ]

          environment = [
            for name, value in var.environment_variables :
            {
              name  = name
              value = value
            }
          ]

          secrets = [
            for name, arn in var.environment_secrets_arns :
            {
              name      = name
              valueFrom = arn
            }
          ]

          # Fargate does not support tmpfs, making read-only overly restrictive
          readonlyRootFilesystem = false
          privileged             = false
          user                   = "${var.run_as_user}:${var.run_as_group}"

          linuxParameters = {
            capabilities = {
              drop = ["ALL"]
            }
          }

          logConfiguration = {
            logDriver = "awslogs"

            options = {
              awslogs-group         = var.cloudwatch_log_group_name
              awslogs-stream-prefix = var.name
              awslogs-region        = data.aws_region.current.name
            }
          }
        },
        var.docker_cmd != null ? { command = var.docker_cmd } : {},
        var.docker_entrypoint != null ? { entryPoint = var.docker_entrypoint } : {}
      )
    ]
  )
}

resource "aws_ecs_service" "this" {
  name            = var.name
  cluster         = var.cluster_arn
  task_definition = aws_ecs_task_definition.this.arn

  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"
  desired_count                      = var.desired_count
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 50
  health_check_grace_period_seconds  = 30

  deployment_controller {
    type = "ECS"
  }

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = [aws_security_group.ecs_tasks.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.this.arn
    container_name   = var.name
    container_port   = var.container_port
  }

  wait_for_steady_state = true
}

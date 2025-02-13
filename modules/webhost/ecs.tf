# Defs for ECS resources

resource "aws_ecs_cluster" "webserver" {
  name = "${var.namespace}-${var.environment}-cluster"

  tags = merge(
    local.global_tags,
    { Name = "${var.namespace}-${var.environment}-cluster" }
  )
}

# !!      !! 
# !! NOTE !! This is a minimally-sized task definition for the purposes of this project.
# !!      !! The CPU/Memory must be sized up (in the vars provided to the module) to support real workloads in a prod environment.

resource "aws_ecs_task_definition" "webserver" {
  family = "${var.namespace}-${var.environment}"
  container_definitions = jsonencode([
    {
      cpu       = var.ecs_cpu,
      memory    = var.ecs_mem,
      essential = true
      image     = "nginx:alpine"
      name      = "${var.namespace}-${var.environment}"
      portMappings = [{
        containerPort = var.ecs_port,
        hostPort      = var.ecs_port,
        protocol      = "tcp"
      }],
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = aws_cloudwatch_log_group.webserver.name,
          awslogs-region        = data.aws_region.current.name,
          awslogs-stream-prefix = "ecs"
        }
      },
      healthCheck = {
        command  = ["CMD-SHELL", "curl -f http://localhost:${var.ecs_port}/ || exit 1"]
        interval = 30
        retries  = 3
        timeout  = 5
      }
    }
  ])

  cpu                      = var.ecs_cpu
  memory                   = var.ecs_mem
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.webserver_ecs_task.arn
  task_role_arn            = aws_iam_role.webserver_ecs_task.arn

  tags = merge(
    local.global_tags,
    { Name = "${var.namespace}-${var.environment}-taskdef" }
  )
}


# !!      !!
# !! NOTE !! This is a minimally-sized service definition for the purposes of this project.
# !!      !! The desired count should be increased (in the vars provided to the module) to support real workloads in a prod environment.

resource "aws_ecs_service" "webserver" {
  name            = "${var.namespace}-${var.environment}"
  task_definition = aws_ecs_task_definition.webserver.arn
  cluster         = aws_ecs_cluster.webserver.arn
  desired_count   = var.ecs_desired_tasks
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = aws_lb_target_group.webserver.arn
    container_name   = "${var.namespace}-${var.environment}"
    container_port   = var.ecs_port
  }

  network_configuration {
    subnets = [aws_subnet.public_1_a.id, aws_subnet.public_2_b.id]
    security_groups = [
      aws_security_group.webserver.id
    ]
    assign_public_ip = true
  }

}

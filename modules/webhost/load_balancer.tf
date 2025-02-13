# define load-balancer related resources for our project

resource "aws_lb" "webserver" {
  name                             = "${var.namespace}-${var.environment}"
  internal                         = false
  load_balancer_type               = "application"
  enable_cross_zone_load_balancing = true
  subnets                          = [aws_subnet.public_1_a.id, aws_subnet.public_2_b.id]
  security_groups                  = [aws_security_group.webserver_lb.id]

  access_logs {
    bucket  = aws_s3_bucket.lb_logs.id
    prefix  = "${var.namespace}-${var.environment}-lb-logs"
    enabled = true
  }

  tags = merge(
    local.global_tags,
    { Name = "loadbalancer-${var.environment}" }
  )
}

# Target group with which ECS will associate tasks
resource "aws_lb_target_group" "webserver" {
  name        = "${var.namespace}-${var.environment}-tg"
  port        = var.ecs_port
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"
}

# Listen on the given port
resource "aws_lb_listener" "webserver" {
  load_balancer_arn = aws_lb.webserver.arn
  port              = var.ecs_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webserver.arn
  }
}

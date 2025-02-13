# Security Group for webserver ECS tasks
resource "aws_security_group" "webserver" {
  name        = "${var.namespace}-${var.environment}-sg"
  description = "SG describing ${var.namespace}-${var.environment} network access"
  vpc_id      = aws_vpc.main.id

  tags = merge(
    local.global_tags,
    { Name = "${var.namespace}-${var.environment}-sg" }
  )
}

# allow all inbound on port 80
resource "aws_security_group_rule" "webserver_http_ingress" {
  security_group_id        = aws_security_group.webserver.id
  type                     = "ingress"
  from_port                = var.ecs_port
  to_port                  = var.ecs_port
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.webserver_lb.id
  description              = "Ingress port ${var.ecs_port} from ALL"
}

# allow all outbound on 443 (to grab docker image)
resource "aws_security_group_rule" "webserver_https_egress" {
  security_group_id = aws_security_group.webserver.id
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Egress port 443 to ALL"
}

# Security Group for the load balancer (clients hit this directly)
resource "aws_security_group" "webserver_lb" {
  name        = "${var.namespace}-${var.environment}-lb-sg"
  description = "SG for the ${var.namespace} LB"
  vpc_id      = aws_vpc.main.id

  tags = merge(
    local.global_tags,
    { Name = "${var.namespace}-${var.environment}-sg" }
  )
}

# Load balancer listen on given port
resource "aws_security_group_rule" "webserver_lb_http_ingress" {
  security_group_id = aws_security_group.webserver_lb.id
  type              = "ingress"
  from_port         = var.ecs_port
  to_port           = var.ecs_port
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Ingress port ${var.ecs_port} to LB from ALL"
}

# Load balancer communicate with ECS tasks in the two subnets
resource "aws_security_group_rule" "webserver_lb_http_egress_local" {
  security_group_id = aws_security_group.webserver_lb.id
  type              = "egress"
  from_port         = var.ecs_port
  to_port           = var.ecs_port
  protocol          = "tcp"
  cidr_blocks       = [aws_subnet.public_1_a.cidr_block, aws_subnet.public_2_b.cidr_block]
  description       = "Egress from LB port ${var.ecs_port} to ECS"
}

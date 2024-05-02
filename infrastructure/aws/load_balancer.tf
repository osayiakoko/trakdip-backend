// Create a load balancer for the Fargate service
resource "aws_lb" "api_service" {
  name               = "${var.project_name}-api-${var.environment}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.load_balancer.id]
  subnets            = [for subnet in aws_subnet.public : subnet.id]

  enable_deletion_protection = false
}

// Create a target group for the load balancer
resource "aws_lb_target_group" "api_service" {
  name        = "${var.project_name}-api-tg-${var.environment}"
  port        = var.api_port
  protocol    = var.api_protocol
  target_type = "ip"
  vpc_id      = aws_vpc.main.id

  health_check {
    path                = "/"
    protocol            = var.api_protocol
    port                = "traffic-port"
    healthy_threshold   = "3"
    interval            = "30"
    matcher             = "200"
    timeout             = "3"
    unhealthy_threshold = "2"
  }
}

// Create a listener for the load balancer
# Redirect all traffic from the ALB to the target group
resource "aws_lb_listener" "api_service" {
  load_balancer_arn = aws_lb.api_service.arn
  port              = var.api_port
  protocol          = var.api_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api_service.arn
  }
}

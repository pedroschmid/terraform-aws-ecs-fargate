# ALB #

# ALB itself
resource "aws_lb" "this" {
  name               = "alb-${var.ENVIRONMENT}"
  load_balancer_type = "application"
  internal           = false
  security_groups    = [aws_security_group.alb.id]
  subnets            = aws_subnet.public.*.id
}

# Target group default
resource "aws_alb_target_group" "default" {
  name        = "default-tg-${var.ENVIRONMENT}"
  port        = 3000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.this.id

  health_check {
    path                = "/health_check"
    port                = "traffic-port"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 2
    interval            = 5
    matcher             = "200"
  }
}

# ALB listener
resource "aws_alb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = "80"
  protocol          = "HTTP"
  depends_on        = [aws_alb_target_group.default]

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.default.arn
  }
}
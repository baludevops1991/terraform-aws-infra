# Target Group for ASG instances
resource "aws_lb_target_group" "uat_tg" {
  name        = "${var.vpc_name}-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.uat_vpc.id
  target_type = "instance"
  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-399"
  }

  # Attach WAF Web ACL directly
  #web_acl_arn = aws_wafv2_web_acl.alb_waf.arn

  tags = {
    Name        = "${var.vpc_name}-tg"
    Environment = var.environment
  }
}

# Application Load Balancer
resource "aws_lb" "uat_alb" {
  name               = "${var.vpc_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = aws_subnet.public-subnets[*].id

  tags = {
    Name        = "${var.vpc_name}-alb"
    Environment = var.environment
  }
}

# ALB Listener - forwards HTTP to the Target Group
resource "aws_lb_listener" "uat_listener" {
  load_balancer_arn = aws_lb.uat_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.uat_tg.arn
  }
}

# Attach ASG to Target Group (Explicit is optional, but clearer)
resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.uat_asg.name
  lb_target_group_arn    = aws_lb_target_group.uat_tg.arn
}

/*# Associate WAF with ALB
resource "aws_wafv2_web_acl_association" "uat_alb_assoc" {
  resource_arn = aws_lb.uat_alb.arn
  web_acl_arn  = aws_wafv2_web_acl.uat_acl.arn
}*/



resource "aws_lb_target_group" "target-group" {
  name     = "${var.COMPONENT}-${var.ENV}"
  port     = var.PORT
  protocol = "HTTP"
  vpc_id   = var.VPC_ID

  health_check {
    enabled = true
    healthy_threshold = 2
    unhealthy_threshold = 2
    interval = 6
    path = "/health"
    timeout = 5
  }
}

#resource "aws_lb_target_group_attachment" "attach" {
#  count            = var.INSTANCE_COUNT
#  target_group_arn = aws_lb_target_group.target-group.arn
#  target_id        = aws_spot_instance_request.instance.*.spot_instance_id[count.index]
#  port             = var.PORT
#}

resource "aws_lb_target_group_attachment" "attach" {
    count            = var.INSTANCE_COUNT
    target_group_arn = aws_lb_target_group.target-group.arn
    target_id        = aws_instance.instance.*.id[count.index]
    port             = var.PORT
  }

resource "aws_lb_listener" "frontend" {
  count             = var.LB_TYPE == "public" ? 1 : 0
  load_balancer_arn = var.LB_ARN
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:us-east-1:794750663080:certificate/816d3e06-deab-4142-abdd-ed71142ca0d9"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-group.arn
  }
}

resource "random_integer" "priority" {
  min = 1
  max = 50000
}

resource "aws_lb_listener_rule" "backend" {
  count             = var.LB_TYPE == "private" ? 1 : 0
  listener_arn = var.PRIVATE_LISTENER_ARN
  priority     = random_integer.priority.result

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-group.arn
  }

  condition {
    host_header {
      values = ["${var.COMPONENT}-${var.ENV}.roboshop.internal"]
    }
  }

}

resource "aws_lb_target_group" "target-group" {
  name     = "${var.COMPONENT}-${var.ENV}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.VPC_ID



  health_check = {
    enabled = true
    healthy_threshold = 2
    unhealthy_threshold = 2
    interval = 5
    path = "/health"
  }
}


resource "aws_lb_target_group_attachment" "attach" {
  count = var.INSTANCE_COUNT
  target_group_arn = var.LB_ARN
  target_id        = aws_spot_instance_request.instance.*.spot_instance_id[count.index]
  port             = var.PORT
}


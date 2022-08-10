resource "aws_route53_record" "private" {
  zone_id = var.PRIVATE_ZONE_ID
  name    = "${var.COMPONENT}-${var.ENV}"
  type    = "CNAME"
  ttl     = 300
  records = [var.PRIVATE_LB_DNS]
}
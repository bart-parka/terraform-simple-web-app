resource "aws_route53_record" "app" {
  zone_id = data.aws_route53_zone.bartparka.zone_id
  name    = "${var.stage}.${var.app_name}"
  type    = "A"

  alias {
    name                   = aws_lb.app.dns_name
    zone_id                = aws_lb.app.zone_id
    evaluate_target_health = true
  }
}

data "aws_route53_zone" "bartparka" {
  name = "bartparka.com"
}
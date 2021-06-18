provider "aws" {
  region = "${var.region}"
}


resource "aws_alb_target_group" "odoo_tg"{
  name        = "odoo-${var.environment}"
  port        = 8069
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = "${var.vpc_id}"
}

resource "aws_lb" "beracah_lb" {
  name                = "berach-elb-${var.environment}"
  internal            = false
  load_balancer_type  = "application"
  security_groups     = "${var.security_group_ids}"
  subnets             = "${var.public_subnet_ids}"


  tags = {
    Name = "berach-elb-${var.environment}"
  }
}

resource "aws_alb_listener" "front-end" {
  load_balancer_arn   = aws_lb.beracah_lb.arn
  port                = "443"
  protocol            = "HTTPS"
  ssl_policy          = "ELBSecurityPolicy-2016-08"
  certificate_arn     = "${var.ssl_certificate_arn}"

  default_action {
    type              = "forward"
    target_group_arn  = aws_alb_target_group.odoo_tg.arn
  }

}

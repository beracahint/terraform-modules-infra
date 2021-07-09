provider "aws" {
  region = "${var.region}"
}


//resource "aws_alb_target_group" "odoo_tg"{
//  name        = "odoo-${var.environment}"
//  port        = 8069
//  protocol    = "HTTP"
//  target_type = "ip"
//  vpc_id      = "${var.vpc_id}"
//}

resource "aws_alb_target_group" "odoo_tg" {
  name                          = "odoo-${var.environment}"
  port                          = 8069
  protocol                      = "HTTP"
  vpc_id                        = var.vpc_id
  target_type                   = "ip"
  load_balancing_algorithm_type = "round_robin"
  deregistration_delay          = "300"
  health_check {
    enabled             = "true"
    healthy_threshold   = "5"
    interval            = "30"
    matcher             = "200-499"
    path                = "/"
    port                = "8069"
    protocol            = "HTTP"
    timeout             = "5"
    unhealthy_threshold = "2"
  }
}

resource "aws_alb_target_group" "magento_tg" {
  name                          = "magento-${var.environment}"
  port                          = 80
  protocol                      = "HTTP"
  vpc_id                        = var.vpc_id
  target_type                   = "ip"
  load_balancing_algorithm_type = "round_robin"
  deregistration_delay          = "300"
  health_check {
    enabled             = "true"
    healthy_threshold   = "5"
    interval            = "30"
    matcher             = "200-499"
    path                = "/"
    port                = "80"
    protocol            = "HTTP"
    timeout             = "5"
    unhealthy_threshold = "2"
  }
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

resource "aws_lb_listener" "https_listener" {
  load_balancer_arn   = aws_lb.beracah_lb.arn
  port                = "443"
  protocol            = "HTTPS"
  ssl_policy          = "ELBSecurityPolicy-2016-08"
  certificate_arn     = "${var.ssl_certificate_arn}"

  default_action {
    type              = "forward"
    target_group_arn  = aws_alb_target_group.magento_tg.arn
  }

}


resource "aws_lb_listener_rule" "magento_rule_prod" {
  listener_arn = aws_lb_listener.https_listener.arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.magento_tg.arn
  }

  condition {
    host_header {
      values = ["www.beracahmedica.mx"]
    }
  }
}

resource "aws_lb_listener_rule" "magento_rule_nonprod" {
  listener_arn = aws_lb_listener.https_listener.arn
  priority     = 2

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.magento_tg.arn
  }

  condition {
    host_header {
      values = ["stage.beracahmedica.mx"]
    }
  }
}

resource "aws_lb_listener_rule" "odoo_rule_nonprod" {
  listener_arn = aws_lb_listener.https_listener.arn
  priority     = 3

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.odoo_tg.arn
  }

  condition {
    host_header {
      values = ["erp.stage.beracahmedica.mx"]
    }
  }
}

resource "aws_lb_listener_rule" "odoo_rule_prod" {
  listener_arn = aws_lb_listener.https_listener.arn
  priority     = 4

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.odoo_tg.arn
  }

  condition {
    host_header {
      values = ["erp.beracahmedica.mx"]
    }
  }
}

resource "aws_lb_listener_rule" "magento_rule_prod2" {
  listener_arn = aws_lb_listener.https_listener.arn
  priority     = 5

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.magento_tg.arn
  }

  condition {
    host_header {
      values = ["prod.beracahmedica.mx"]
    }
  }
}



resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.beracah_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
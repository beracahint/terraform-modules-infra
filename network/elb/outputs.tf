output elb_id {
  value = aws_lb.beracah_lb.id
}

output odoo_tg_arn {
  value = aws_alb_target_group.odoo_tg.arn
}

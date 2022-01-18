
output odoo_efs_id {
  value = aws_efs_file_system.odoo_efs.id
}

output "odoo_efs_access_point_arn" {
  value = aws_efs_access_point.odoo_efs_access_point.arn
}

output odoo_efs_arn {
  value = aws_efs_file_system.odoo_efs.arn
}

output "odoo_efs_access_point_id" {
  value = aws_efs_access_point.odoo_efs_access_point.id
}
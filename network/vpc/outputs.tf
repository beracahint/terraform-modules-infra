

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnet.*.id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnet.*.id
}

output "default_vpc_sg_id" {
  value = aws_security_group.default.id
}

output "odoo_sg_id" {
  value = aws_security_group.odoo_sg.id
}

output "magento_sg_id" {
  value = aws_security_group.magento_sg.id
}

output "elb_sg_id" {
  value = aws_security_group.elb_sg.id
}

output "magento_db_sg_id" {
  value = aws_security_group.magento_db_sg.id
}

output "sp_db_sg_id" {
  value = aws_security_group.sp_db_sg.id
}

output "odoo_db_sg_id" {
  value = aws_security_group.odoo_db_sg.id
}

output "odoo_efs_sg"{
  value = aws_security_group.odoo_efs_sg.id
}
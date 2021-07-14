provider "aws" {
  region = "${var.region}"
}


resource "aws_db_subnet_group" "odoo_subnet_group" {
  name       = "odoo"
  subnet_ids = var.subnet_ids_group

  tags = {
    Name = "odoo-subnet-group"
  }
}

resource "aws_db_instance" "odoo_db" {
  allocated_storage    = var.allocated_storage
  instance_class       = var.instance_class
  name                 = var.db_name
  identifier           = var.db_name
  vpc_security_group_ids = var.security_groups
  snapshot_identifier  = var.snapshot_arn
  engine               = var.engine
  db_subnet_group_name = aws_db_subnet_group.odoo_subnet_group.id
  lifecycle {
    ignore_changes = [snapshot_identifier]
  }
  skip_final_snapshot = var.skip_final_snapshot
  publicly_accessible = var.publicly_accessible
}


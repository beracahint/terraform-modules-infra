resource "aws_efs_file_system" "odoo_efs" {
  tags = {
    Name = var.odoo_efs_name
  }
}

resource "aws_efs_file_system_policy" "policy" {
  file_system_id = aws_efs_file_system.odoo_efs.id

  policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Id": "ExamplePolicy01",
    "Statement": [
        {
            "Sid": "DenyInsecureTraffic",
            "Effect": "Deny",
            "Principal": {
                "AWS": "*"
            },
            "Action": "*",
            "Resource": "${aws_efs_file_system.odoo_efs.arn}",
            "Condition": {
                "Bool": {
                    "aws:SecureTransport": "false"
                }
            }
        }
    ]
  }
  POLICY
}


resource "aws_efs_mount_target" "efs_mount_private_subnet_1" {
  file_system_id = aws_efs_file_system.odoo_efs.id
  subnet_id      = var.private_subnet_1_id
  security_groups = var.efs_mount_security_groups
}

resource "aws_efs_mount_target" "efs_mount_private_subnet_2" {
  file_system_id = aws_efs_file_system.odoo_efs.id
  subnet_id      = var.private_subnet_2_id
  security_groups = var.efs_mount_security_groups
}

resource "aws_efs_access_point" "odoo_efs_access_point" {
  file_system_id = aws_efs_file_system.odoo_efs.id
  posix_user {
    gid = 1000
    uid = 1000
  }
  root_directory {
    path = var.odoo_efs_path
    creation_info {
      owner_gid = 1000
      owner_uid = 1000
      permissions = "755"
    }
  }
}
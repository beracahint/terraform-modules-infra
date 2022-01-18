variable "cpu" {}
variable "memory" {}
variable "memory_reservation" {
  type = number
}
variable "execution_role_arn" {}
variable "task_role_arn" {}
variable "environment" {}
variable "region" {}
variable "odoo-image" {}
variable "cluster_id" {}
variable "odoo_tg_arn" {}
variable "security_group_ids" {
  type = list(string)
}
variable subnet_ids {
  type = list(string)
}
variable db_host {}
variable db_user {}
variable db_password {}
variable file_system_id {}
variable file_system_access_point_id {}
variable container_filesystem_path {}

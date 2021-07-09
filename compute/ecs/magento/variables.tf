variable region {}
variable task_role_arn {}
variable execution_role_arn {}
variable cpu {}
variable memory {}
variable magento_image {}
variable logs_prefix {}
variable cluster_id {}
variable magento_tg_arn {}
variable environment {}
variable "security_group_ids" {
  type = list(string)
}
variable subnet_ids {
  type = list(string)
}
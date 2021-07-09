variable "region" {}
variable environment {}
variable ssl_certificate_arn {}
variable security_group_ids {
  type = list(string)
}
variable public_subnet_ids {
  type = list(string)
}
variable vpc_id {}


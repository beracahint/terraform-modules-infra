variable allocated_storage {}
variable instance_class {}
variable db_name {
  type = string
}
variable vpc_id {}
variable security_groups {
  type = list(string)
}
variable region {}
variable environment {}
variable subnet_ids_group {
  type = list(string)
}
variable engine {}
variable skip_final_snapshot {
  type = bool
}
variable publicly_accessible {
  type = bool
}
variable username {}
variable password {}
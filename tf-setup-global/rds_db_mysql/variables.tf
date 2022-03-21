variable "db_description" {
  type=object({
      db_subnets = list(string)
      db_identifier = string
      storage_type = string
      instance_type = string
      port_db = string
      db_name = string
      username = string
      password = string
      availability_zone = string
      security_groups = list(string)
      is_multi_az = bool
  })
}
variable "region" {
  type=string
  default = "sa-east-1"
}
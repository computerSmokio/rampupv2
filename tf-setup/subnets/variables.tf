variable "public_subnets" {
  type = list(object({
      cidr_block = string
      availability_zone = string
      attach_public = bool
  }))
}
variable "private_subnets" {
  type = list(object({
      cidr_block = string
      availability_zone = string
  }))
}

variable "vpc" {
  type = string
}
variable "loadb_description" {
  type = object({
      name = string
      isInternal = bool
      type = string
      subnets = list(string)
      tags = map(string)
  })
}

variable "target_description" {
  type = object({
      name = string
      port = number
      protocol = string
      type = string
      targets = list(object({
          ip = string
          port = number
      }))
  })
}

variable "vpc_id" {
  type = string
}
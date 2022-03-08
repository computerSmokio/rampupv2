variable "instances" {
    type = list(object({
        ami = string
        instance_type = string
        security_groups = list(string)
        subnet_id = string
        instance_profile = string
        user_data64 = string
        tags = map(string)
    }))
}
variable "key_name" {
    type = string
}
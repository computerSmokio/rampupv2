resource "aws_instance" "ec2_instances" {
    for_each = {for instance in var.instances: instance.tags["Name"] => instance}
    ami                    = each.value.ami
    instance_type          = each.value.instance_type
    vpc_security_group_ids = each.value.security_groups
    subnet_id              = each.value.subnet_id
    iam_instance_profile = each.value.instance_profile
    key_name               = var.key_name
    user_data = each.value.user_data
    tags                   = each.value.tags
}
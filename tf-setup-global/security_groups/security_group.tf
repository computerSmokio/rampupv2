resource "aws_security_group" "security_groups" {
    for_each = {for sg in var.security_groups: sg.name => sg}
    name        = each.key
    description = each.value.description
    vpc_id      = var.vpc
    dynamic "ingress"{
        for_each = each.value.ingress
        content {
            description = ingress.value["description"]
            from_port = ingress.value["from_port"]
            to_port = ingress.value["to_port"]
            protocol = ingress.value["protocol"]
            cidr_blocks = ingress.value["cidr_blocks"]
        }
    }
    dynamic "egress"{
        for_each = each.value.egress
        content {
            description = egress.value["description"]
            from_port = egress.value["from_port"]
            to_port = egress.value["to_port"]
            protocol = egress.value["protocol"]
            cidr_blocks = egress.value["cidr_blocks"]
        }
    }
    tags = each.value.tags
}
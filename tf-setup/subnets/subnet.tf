resource "aws_subnet" "private_subnet" {
    for_each = {for subnet in var.private_subnets: subnet.cidr_block => subnet}
    vpc_id                  = var.vpc
    cidr_block              = each.value.cidr_block
    map_public_ip_on_launch = false
    availability_zone       = each.value.availability_zone
    tags                    = { Name = format("%s%s", "private_subnet_", each.value.availability_zone),
    "kubernetes.io/cluster/rampupCluster" = "shared" }
}

resource "aws_subnet" "public_subnet" {
    for_each = {for subnet in var.public_subnets: subnet.cidr_block => subnet}
    vpc_id                  = var.vpc
    cidr_block              = each.value.cidr_block
    map_public_ip_on_launch = each.value.attach_public
    availability_zone       = each.value.availability_zone
    tags                    = { Name = format("%s%s", "public_subnet_", each.value.availability_zone),
    "kubernetes.io/cluster/rampupCluster" = "shared" }
}
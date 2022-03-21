output "vpc_id" {
    value = aws_vpc.public_private_vpc.id
}

output "public_subnet_ids" {
    value = module.subnets.subnets.public_subnet
}
output "private_subnet_ids" {
    value = module.subnets.subnets.private_subnet
}

output "subnets" {
  value = {
    public_subnet = [for sub in aws_subnet.public_subnet: sub.id] 
    private_subnet = [for sub in aws_subnet.private_subnet: sub.id]
  }
}

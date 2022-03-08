output "ec2_instances" {
  value = zipmap([for ec2 in aws_instance.ec2_instances: ec2.tags["Name"]],[for ec2 in aws_instance.ec2_instances: ec2.id])
}
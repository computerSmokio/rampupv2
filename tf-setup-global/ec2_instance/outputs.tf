output "ec2_instances" {
  value = {for instance in aws_instance.ec2_instances : instance.tags["Name"] => instance}
}
output "security_groups" {
  value = {for sg in aws_security_group.security_groups: sg.name => sg.id}
}
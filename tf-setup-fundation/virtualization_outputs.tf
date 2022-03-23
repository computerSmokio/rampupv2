output "chef_ip" {
    value = module.ec2_instances.ec2_instances["Bastion Host"].private_ip
}
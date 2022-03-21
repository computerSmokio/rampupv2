variable "key_name" {
    type = string
}

locals {
    ec2_instances = [
        {
            ami = "ami-06078a297452ba5aa"
            instance_type = "t2.medium"
            subnet_id = module.subnets.subnets.public_subnet[0]
            security_groups = [module.security_groups.security_groups["bastion-host-sg"]]
            instance_profile = ""
            user_data = file("/home/mavargas/rampup-part-II/scripts-user-data/bastion_host.bash")
            tags = {"Name" = "Bastion Host"}
        },
    ]
}
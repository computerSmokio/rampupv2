variable "key_name" {
    type = string
}

locals {
    ec2_instances = [
        {
            ami = "ami-06078a297452ba5aa"
            instance_type = "t2.micro"
            subnet_id = module.subnets.subnets.public_subnet[0]
            security_groups = [module.security_groups.security_groups["bastion-host-sg"]]
            instance_profile = ""
            user_data64 = filebase64("/home/mavargas/rampup-part-II/scripts-user-data/bastion_host.bash")
            tags = {"Name" = "Bastion Host"}
        },
        {
            ami = "ami-06078a297452ba5aa"
            instance_type = "t2.micro"
            subnet_id = module.subnets.subnets.private_subnet[0]
            security_groups = [module.security_groups.security_groups["master-node-sg"]]
            instance_profile = ""
            user_data64 = filebase64("/home/mavargas/rampup-part-II/scripts-user-data/master_node.bash")
            tags = {"Name" = "Master Node"}
        },
        {
            ami = "ami-06078a297452ba5aa"
            instance_type = "t2.micro"
            subnet_id = module.subnets.subnets.private_subnet[0]
            security_groups = [module.security_groups.security_groups["worker-node-sg"]]
            instance_profile = ""
            user_data64 = filebase64("/home/mavargas/rampup-part-II/scripts-user-data/worker_node.bash")
            tags = {"Name" = "Worker Node"}
        }
    ]
}
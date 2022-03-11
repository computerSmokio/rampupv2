variable "key_name" {
    type = string
}
variable "db_username" {
  type = string
}
variable "db_password" {
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
            user_data = file("/home/mavargas/rampup-part-II/scripts-user-data/bastion_host.bash")
            tags = {"Name" = "Bastion Host"}
        },
        {
            ami = "ami-06078a297452ba5aa"
            instance_type = "t2.micro"
            subnet_id = module.subnets.subnets.private_subnet[0]
            security_groups = [module.security_groups.security_groups["master-node-sg"]]
            instance_profile = "k8-test-master"
            user_data = file("/home/mavargas/rampup-part-II/scripts-user-data/master_node.bash")
            tags = {"Name" = "Master Node"
            }
        },
        {
            ami = "ami-06078a297452ba5aa"
            instance_type = "t2.micro"
            subnet_id = module.subnets.subnets.private_subnet[0]
            security_groups = [module.security_groups.security_groups["worker-node-sg"]]
            instance_profile = "k8-test-master"
            user_data = file("/home/mavargas/rampup-part-II/scripts-user-data/worker_node.bash")
            tags = {"Name" = "Worker Node"
            }
        }
    ]
    db_description = {
        db_subnets = module.subnets.subnets.private_subnet
        db_identifier = "mysql-db"
        storage_type = "gp2"
        instance_type = "db.t2.micro"
        port_db = var.port_db
        db_name = "movie_db"
        username = var.db_username
        password = var.db_password
        availability_zone = "${var.region}a"
        security_groups = [module.security_groups.security_groups["mysql-sg"]]
        is_multi_az = false
    }

}
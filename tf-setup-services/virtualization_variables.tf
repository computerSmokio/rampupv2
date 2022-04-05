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
            amount = 1
            ami = "ami-06078a297452ba5aa"
            instance_type = "t2.small"
            subnet_id = data.terraform_remote_state.fundation.outputs.private_subnet_ids[0]
            security_groups = [module.security_groups.security_groups["master-node-sg"]]
            instance_profile = "k8-test-master"
            user_data = templatefile("./../scripts-user-data/worker_node.bash", {
                chef_server_ip = data.terraform_remote_state.fundation.outputs.chef_ip
            })            
            tags = {"Name" = "Master Node"}
        },
        {
            ami = "ami-06078a297452ba5aa"
            instance_type = "t2.micro"
            subnet_id = data.terraform_remote_state.fundation.outputs.private_subnet_ids[0]
            security_groups = [module.security_groups.security_groups["worker-node-sg"]]
            instance_profile = "k8-test-master"
            user_data = templatefile("./../scripts-user-data/worker_node.bash", {
                chef_server_ip = data.terraform_remote_state.fundation.outputs.chef_ip
            })
            tags = {"Name" = "Worker Node 1"}
        },
        {
            ami = "ami-06078a297452ba5aa"
            instance_type = "t2.small"
            subnet_id = data.terraform_remote_state.fundation.outputs.private_subnet_ids[0]
            security_groups = [module.security_groups.security_groups["worker-node-sg"]]
            instance_profile = "k8-test-master"
            user_data = templatefile("./../scripts-user-data/worker_node.bash", {
                chef_server_ip = data.terraform_remote_state.fundation.outputs.chef_ip
            })
            tags = {"Name" = "Worker Node 2"}
        }
    ]
    db_description = {
        db_subnets = data.terraform_remote_state.fundation.outputs.private_subnet_ids
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
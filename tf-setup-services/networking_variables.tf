variable "region" {
    type = string
    default = "sa-east-1"
}
variable "frontend_port" {
  type = string
  default = "3030"
}
variable "backend_port" {
  type    = string
  default = "3000"
}
variable "port_db" {
  type    = string
  default = "3306"
}
locals {
    security_groups = [ 
        {
            name = "master-node-sg"
            description = "Master node security group"
            egress = [ {
                description = "Allow any egress"
                from_port   = 0
                to_port     = 0
                protocol    = -1
                cidr_blocks = ["0.0.0.0/0"]
            } ]
            ingress = [ 
            {
                description       = "Allow ssh"
                from_port         = 22
                to_port           = 22
                protocol          = "tcp"
                cidr_blocks       = ["10.0.0.0/16"]
            },
            {
                description       = "Allow kubeadm"
                from_port         = 6443
                to_port           = 6443
                protocol          = "tcp"
                cidr_blocks       = ["10.0.3.0/24"]
            },
            {
                description       = "Allow encapsulation"
                from_port         = 8472
                to_port           = 8472
                protocol          = "udp"
                cidr_blocks       = ["10.0.3.0/24"]
            }            
            ] 
            tags = {"Name" = "master-node-sg"}
        },
        {
            name = "worker-node-sg"
            description = "worker node security group"
            egress = [ {
                description = "Allow any egress"
                from_port   = 0
                to_port     = 0
                protocol    = -1
                cidr_blocks = ["0.0.0.0/0"]
            } ]
            ingress = [ 
            {
                description       = "Allow ssh"
                from_port         = 22
                to_port           = 22
                protocol          = "tcp"
                cidr_blocks       = ["10.0.0.0/16"]
            },
            {
                description       = "Allow kubeadm"
                from_port         = 6443
                to_port           = 6443
                protocol          = "tcp"
                cidr_blocks       = ["10.0.3.0/24"]
            },
            {
                description = "Allow db port"
                from_port   = var.port_db
                to_port     = var.port_db
                protocol    = "tcp"
                cidr_blocks = ["10.0.3.0/24"]
            },
            {
                description = "Allow NLB"
                from_port   = 30100
                to_port     = 30100
                protocol    = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
            },
            {
                description       = "Allow encapsulation"
                from_port         = 8472
                to_port           = 8472
                protocol          = "udp"
                cidr_blocks       = ["10.0.3.0/24"]
            },
            {
                description       = "Allow logs"
                from_port         = 10250
                to_port           = 10250
                protocol          = "tcp"
                cidr_blocks       = ["10.0.3.0/24"]
            }
            ] 
            tags = {"Name" = "worker-node-sg"}
        },
        {
            name = "mysql-sg"
            description = "mysql security group"
            egress = [ {
                description = "Allow any egress"
                from_port   = 0
                to_port     = 0
                protocol    = -1
                cidr_blocks = ["0.0.0.0/0"]
            } ]
            ingress = [ 
            {
                description       = "Allow db query"
                from_port         = var.port_db
                to_port           = var.port_db
                protocol          = "tcp"
                cidr_blocks       = ["10.0.3.0/24"]
            }
            ]
            tags = {"Name" = "mysql-db-sg"}
        }
    ]
    loadb_description = {
        name = "cluster-lb"
        isInternal = false
        type = "network"
        subnets = [data.terraform_remote_state.fundation.outputs.public_subnet_ids[0]]
        tags = { "Name" = "Cluster Load Balancer"}
    }
    target_group = {
        name = "cluster-workers-target-group"
        port = 30100
        protocol = "TCP"
        type = "ip"
        targets = [
            {
                ip = module.ec2_instances.ec2_instances["Worker Node 1"].private_ip
                port = 30100
            },
            {
                ip = module.ec2_instances.ec2_instances["Worker Node 2"].private_ip
                port = 30100
            }
        ]
    }
}

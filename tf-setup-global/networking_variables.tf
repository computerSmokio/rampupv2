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
    route_tables = [ 
        {
            routes = [ {
                cidr_block = "0.0.0.0/0"
                gateway_id = aws_internet_gateway.internet_gateway.id
                carrier_gateway_id = null
                destination_prefix_list_id = null
                egress_only_gateway_id = null
                instance_id = null
                ipv6_cidr_block = null
                local_gateway_id = null
                nat_gateway_id = null
                network_interface_id = null
                transit_gateway_id = null
                vpc_endpoint_id = null
                vpc_peering_connection_id = null
            }]
            tags = {"Name" = "any_to_ig"}
        },
        {
            routes = [ {
                cidr_block     = "0.0.0.0/0"
                nat_gateway_id = aws_nat_gateway.nat_gateway.id
                gateway_id = null
                carrier_gateway_id = null
                destination_prefix_list_id = null
                egress_only_gateway_id = null
                instance_id = null
                ipv6_cidr_block = null
                local_gateway_id = null
                network_interface_id = null
                transit_gateway_id = null
                vpc_endpoint_id = null
                vpc_peering_connection_id = null
            } ]
            tags = {"Name" = "any_to_nat"}  
        } 
    ]
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
                description       = "Allow https calls"
                from_port         = 443
                to_port           = 443
                protocol          = "tcp"
                cidr_blocks       = ["0.0.0.0/0"]
            },
            {
                description       = "Allow https calls"
                from_port         = 80
                to_port           = 80
                protocol          = "tcp"
                cidr_blocks       = ["0.0.0.0/0"]
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
                description       = "Allow metrics"
                from_port         = 10250
                to_port           = 10250
                protocol          = "tcp"
                cidr_blocks       = ["10.0.3.0/24"]
            },
            {
                description       = "Allow metrics"
                from_port         = 10255
                to_port           = 10255
                protocol          = "tcp"
                cidr_blocks       = ["10.0.3.0/24"]
            },
            {
                description       = "Allow https calls"
                from_port         = 443
                to_port           = 443
                protocol          = "tcp"
                cidr_blocks       = ["0.0.0.0/0"]
            },
            {
                description       = "Allow http"
                from_port         = 80
                to_port           = 80
                protocol          = "tcp"
                cidr_blocks       = ["0.0.0.0/0"]
            }
            ] 
            tags = {"Name" = "worker-node-sg"}
        },
        {
            name = "bastion-host-sg"
            description = "bastion host security group"
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
                cidr_blocks       = ["0.0.0.0/0"]
            },
            {
                description       = "Allow jenkins connection"
                from_port         = 8080
                to_port           = 8080
                protocol          = "tcp"
                cidr_blocks       = ["0.0.0.0/0"]
            }
            ]
            tags = {"Name" = "bastion-host-sg"}
        },
        {
            name = "mysql-sg"
            description = "bastion host security group"
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
    private_subnets = [ 
        {
            availability_zone = "${var.region}a"
            cidr_block = "10.0.3.0/24"
        },
        {
            availability_zone = "${var.region}c"
            cidr_block = "10.0.4.0/24"
        } 
    ]
    public_subnets = [ 
        {
            availability_zone = "${var.region}a"
            cidr_block = "10.0.1.0/24"
            attach_public = true
        },
        {
            availability_zone = "${var.region}c"
            cidr_block = "10.0.2.0/24"
            attach_public = false
        } 
    ]
    loadb_description = {
        name = "cluster-lb"
        isInternal = false
        type = "network"
        subnets = [module.subnets.subnets.public_subnet[0]]
        tags = { "Name" = "Cluster Load Balancer"}
    }
    target_group = {
        name = "cluster-workers-target-group"
        port = 30100
        protocol = "TCP"
        type = "ip"
        targets = [
            {
                ip = module.ec2_instances.ec2_instances["Worker Node"].private_ip
                port = 30100
            }
        ]
    }
}

variable "region" {
    type = string
    default = "sa-east-1"
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
}

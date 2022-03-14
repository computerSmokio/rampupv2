resource "aws_vpc" "public_private_vpc" {
  cidr_block = "10.0.0.0/16"
  tags       = { Name = "public_private_vpc"}
}

module "route_table" {
    source = "./route_table_routes"
    route_tables = local.route_tables
    vpc = aws_vpc.public_private_vpc.id
}

module "subnets" {
    source = "./subnets"
    public_subnets = local.public_subnets
    private_subnets = local.private_subnets
    vpc = aws_vpc.public_private_vpc.id
}

module "security_groups" {
    source = "./security_groups"
    security_groups = local.security_groups
    vpc = aws_vpc.public_private_vpc.id
}

module "network_load_balancer" {
  source = "./load_balancer"
  loadb_description = local.loadb_description
  target_description = local.target_group
  vpc_id = aws_vpc.public_private_vpc.id
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.public_private_vpc.id
  tags = {
    "Name" = "internet_gateway"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.elastic_ip_nat.id
  subnet_id     = module.subnets.subnets.public_subnet[0]
  depends_on = [
    aws_internet_gateway.internet_gateway
  ]
}

resource "aws_eip" "elastic_ip_nat" {
  vpc = true
}

resource "aws_route_table_association" "publicAs" {
  count = 2
  subnet_id      = module.subnets.subnets.public_subnet[count.index]
  route_table_id = module.route_table.route_tables["any_to_ig"]
}

resource "aws_route_table_association" "privateAs" {
  count = 2
  subnet_id      = module.subnets.subnets.private_subnet[count.index]
  route_table_id = module.route_table.route_tables["any_to_nat"]
}
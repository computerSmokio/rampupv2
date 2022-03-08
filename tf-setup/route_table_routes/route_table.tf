resource "aws_route_table" "route_tables" {
    for_each = {for route_t in var.route_tables: route_t.tags["Name"] => route_t}
    vpc_id = var.vpc
    route = each.value.routes
    tags = each.value.tags
}
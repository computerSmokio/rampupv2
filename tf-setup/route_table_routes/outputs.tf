output "route_tables" {
    value = {for rtab in aws_route_table.route_tables: rtab.tags["Name"] => rtab.id}
}

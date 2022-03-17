module "ec2_instances" {
    source = "./ec2_instance"
    instances = local.ec2_instances
    key_name = var.key_name
    depends_on = [
      aws_route_table_association.privateAs,
      aws_route_table_association.publicAs
    ]
}

#module "mysql_db" {
#  source = "./rds_db_mysql"
#  db_description = local.db_description
#}
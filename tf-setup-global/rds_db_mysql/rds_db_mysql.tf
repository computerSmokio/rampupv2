resource "aws_db_subnet_group" "subnet_group_db" {
  name       = "db-subnet-group"
  subnet_ids = var.db_description.db_subnets
}

resource "aws_db_instance" "mysql_db" {
  identifier             = var.db_description.db_identifier
  storage_type           = var.db_description.storage_type
  allocated_storage      = 5
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = var.db_description.instance_type
  port                   = var.db_description.port_db
  name                   = var.db_description.db_name
  username               = var.db_description.username
  password               = var.db_description.password
  availability_zone      = "${var.region}a"
  deletion_protection    = false
  skip_final_snapshot    = true
  vpc_security_group_ids = var.db_description.security_groups
  db_subnet_group_name   = aws_db_subnet_group.subnet_group_db.name
  multi_az               = var.db_description.is_multi_az
}

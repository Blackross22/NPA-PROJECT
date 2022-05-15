##################################################################################
# RESOURCES
##################################################################################
resource "aws_db_subnet_group" "db_webserver" {
  name       = "db_webserver"
  subnet_ids = aws_subnet.Public_Sunnet[*].id

  tags = merge(local.common_tags, { Name = "${var.cName}-DB-Subnet"})
}

resource "aws_db_instance" "rds" {
  identifier             = "webserver"
  instance_class         = var.db_type
  allocated_storage      = 5
  engine                 = "mysql"
  engine_version         = "5.7"
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.db_webserver.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  parameter_group_name   = aws_db_parameter_group.rds.name
  publicly_accessible    = true
  skip_final_snapshot    = true
}

resource "aws_db_parameter_group" "rds" {
  name   = "rds"
  family = "mysql5.7"

  parameter {
    name  = "character_set_server"
    value = "utf8"
  }

  parameter {
    name  = "character_set_client"
    value = "utf8"
  }
}
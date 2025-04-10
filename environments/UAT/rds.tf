# Creates a PostgreSQL Master RDS instance with Multi-AZ support
resource "aws_db_instance" "postgres_master" {
  identifier             = "${var.vpc_name}-postgres-master"
  engine                 = "postgres"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  storage_type           = "gp2"
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  multi_az               = true
  username               = var.db_usernames[0]
  password               = var.db_passwords[0]
  skip_final_snapshot    = true
  publicly_accessible    = false

  tags = {
    Name        = "${var.vpc_name}-postgres-master"
    Environment = var.environment
    Role        = "Master"
  }

  depends_on = [
    aws_db_subnet_group.rds_subnet_group
  ]
}

/*# Creates a PostgreSQL Salve (Read Replica) RDS instance with Multi-AZ support
resource "aws_db_instance" "postgres_slave" {
  identifier             = "${var.vpc_name}-postgres-slave"
  engine                 = "postgres"
  instance_class         = "db.t3.micro"
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  publicly_accessible    = false
  replicate_source_db    = aws_db_instance.postgres_master.id
  skip_final_snapshot    = true

  tags = {
    Name        = "${var.vpc_name}-postgres-slave"
    Environment = var.environment
    Role        = "Slave"
  }

  depends_on = [
    aws_db_instance.postgres_master
  ]
}
*/

/*
resource "aws_secretsmanager_secret" "rds_secret" {
  name = "uat/rds/postgres"
}

resource "aws_secretsmanager_secret_version" "rds_secret_value" {
  secret_id     = aws_secretsmanager_secret.rds_secret.id
  secret_string = jsonencode({
    username = "postgres"
    password = "P@ssword1234"
  })
}


data "aws_secretsmanager_secret" "rds_secret" {
  name = "uat/rds/postgres"
}

data "aws_secretsmanager_secret_version" "rds_secret_value" {
  secret_id = data.aws_secretsmanager_secret.rds_secret.id
}


locals {
  rds_secret = jsondecode(data.aws_secretsmanager_secret_version.rds_secret_value.secret_string)
}

resource "aws_db_instance" "postgres" {
  ...
  username = local.rds_secret.username
  password = local.rds_secret.password
  ...
}
*/
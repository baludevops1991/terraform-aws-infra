# Creates a subnet group for Redis using private subnets 1 and 2 for ElastiCache deployment across multiple AZs.
resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "${var.vpc_name}-redis-subnet-group"
  subnet_ids = slice([for s in aws_subnet.private-subnets : s.id], 0, 2)

  tags = {
    Name        = "${var.vpc_name}-redis-subnet-group"
    Environment = var.environment
  }
}


# Creates a subnet group for RDS using private subnets 3 for high availability across AZs.
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "${var.vpc_name}-rds-subnet-group"
  subnet_ids = slice([for s in aws_subnet.private-subnets : s.id], 1, 3)

  tags = {
    Name        = "${var.vpc_name}-rds-subnet-group"
    Environment = var.environment
  }
}


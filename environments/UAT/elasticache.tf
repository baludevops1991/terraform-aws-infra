# Redis Cluster (single node for now)
resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "${var.vpc_name}-redis"
  engine               = "redis"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis7"
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.redis_subnet_group.name
  security_group_ids   = [aws_security_group.redis_sg.id]

  tags = {
    Name        = "${var.vpc_name}-redis"
    Environment = var.environment
  }

  depends_on = [aws_elasticache_subnet_group.redis_subnet_group]
}

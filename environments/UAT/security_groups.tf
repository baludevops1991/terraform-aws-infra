# Creates a security group allowing inbound SSH (22), HTTP (80), and HTTPS (443) access,
# and allows all outbound traffic from EC2 instances.
resource "aws_security_group" "ec2_sg" {
  name        = "${var.vpc_name}-ec2-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.uat_vpc.id

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Replace with your IP
  }

  ingress {
    description = "HTTP access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.vpc_name}-ec2-sg"
    Environment = var.environment
  }
}

# Creates a security group for the ALB allowing inbound HTTP (80) and HTTPS (443)
# from anywhere and all outbound traffic.
resource "aws_security_group" "alb_sg" {
  name        = "${var.vpc_name}-alb-sg"
  description = "Allow HTTP traffic from internet"
  vpc_id      = aws_vpc.uat_vpc.id

  ingress {
    description = "HTTP from the world"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.vpc_name}-alb-sg"
    Environment = var.environment
  }
}

# Redis Security Group
resource "aws_security_group" "redis_sg" {
  name        = "${var.vpc_name}-redis-sg"
  description = "Allow Redis access"
  vpc_id      = aws_vpc.uat_vpc.id

  ingress {
    description     = "Redis TCP access"
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sg.id] # allow EC2/ASG to talk to Redis
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.vpc_name}-redis-sg"
    Environment = var.environment
  }
}

# Creates a security group for Redis allowing access on port 6379 from EC2/ASG security group,
# and all outbound traffic.
resource "aws_security_group" "openvpn_sg" {
  description = "Allow OpenVPN traffic"
  vpc_id      = aws_vpc.uat_vpc.id

  ingress {
    from_port   = 1194
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"] # Allow OpenVPN connections from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "openvpn-sg"
  }
}

# Creates a security group for PostgreSQL RDS,
# allowing inbound access on port 5432 from EC2/ASG security group and all outbound traffic.
resource "aws_security_group" "rds_sg" {
  name        = "${var.vpc_name}-rds-sg"
  description = "Allow PostgreSQL access"
  vpc_id      = aws_vpc.uat_vpc.id

  ingress {
    description     = "PostgreSQL"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sg.id] # Allow EC2s from ASG to connect
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.vpc_name}-rds-sg"
    Environment = var.environment
  }
}


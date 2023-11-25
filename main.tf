 resource "aws_security_group" "main" {
  name        = "${var.env}-${var.component}-sg"
  description = "${var.env}-${var.component}-sg"
  vpc_id      = var.vpc_id

  ingress {
    description      = "ELASTICACHE"
    from_port        = 6379
    to_port          = 6379
    protocol         = "tcp"
    cidr_blocks      = [var.vpc_cidr]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env}-${var.component}-sg"
  }
}

resource "aws_elasticache_subnet_group" "main" {
  name       = "${var.env}-${var.component}"
  subnet_ids = var.subnets

  tags = {
    Name = "${var.env}-${var.component}"
  }
}

 resource "aws_elasticache_parameter_group" "main" {
   name   = "${var.env}-${var.component}"
   family = "redis6.x"
 }

 resource "aws_elasticache_cluster" "main" {
   cluster_id           = "${var.env}-${var.component}-cluster"
   engine               = "redis"
   engine_version       = "6.2"
   node_type            = var.ec_node_type
   num_cache_nodes      = var.ec_node_count
   parameter_group_name = aws_elasticache_parameter_group.main.name
   port                 = 6379
   security_group_ids   = [aws_security_group.main.id]
   subnet_group_name    = aws_elasticache_subnet_group.main.name
 }

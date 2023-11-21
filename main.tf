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

 resource "aws_elasticache_replication_group" "main" {
   automatic_failover_enabled  = true
   preferred_cache_cluster_azs = ["us-east-1a", "us-east-1b"]
   replication_group_id        = "${var.env}-${var.component}"
   description                 = "${var.env}-${var.component}"
   node_type                   = var.ec_node_type
   num_cache_clusters          = var.ec_node_count
   parameter_group_name        = "default.redis6.x"
   port                        = 6379
   subnet_group_name           = aws_elasticache_subnet_group.main.name
   security_group_ids          = [aws_security_group.main.id]
   at_rest_encryption_enabled  = true
   transit_encryption_enabled  = true
   kms_key_id                  = var.kms_key_id
 }
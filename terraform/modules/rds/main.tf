# ==============================================================================
# RDS MODULE - main.tf
# ==============================================================================

# ------------------------------------------------------------------------------
# DB Subnet Group
# ------------------------------------------------------------------------------
resource "aws_db_subnet_group" "this" {
  name        = "${var.name}-db-subnet-group"
  description = "Subnet group for ${var.name} RDS instance"
  subnet_ids  = var.subnet_ids

  tags = merge(var.tags, {
    Name = "${var.name}-db-subnet-group"
  })
}

# ------------------------------------------------------------------------------
# Security Group for RDS
# ------------------------------------------------------------------------------
resource "aws_security_group" "rds" {
  name        = "${var.name}-rds-sg"
  description = "Security group for ${var.name} RDS"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = var.db_port
    to_port         = var.db_port
    protocol        = "tcp"
    security_groups = var.allowed_security_group_ids
    cidr_blocks     = var.allowed_cidr_blocks
    description     = "Allow DB access"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.name}-rds-sg"
  })
}

# ------------------------------------------------------------------------------
# RDS Instance
# ------------------------------------------------------------------------------
resource "aws_db_instance" "this" {
  identifier        = "${var.name}-db"
  engine            = var.engine
  engine_version    = var.engine_version
  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage
  storage_type      = "gp2"
  storage_encrypted = true

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  multi_az            = var.multi_az
  publicly_accessible = false
  skip_final_snapshot = var.skip_final_snapshot

  final_snapshot_identifier = var.skip_final_snapshot ? null : "${var.name}-final-snapshot"

  backup_retention_period = 0
  deletion_protection     = var.deletion_protection

  tags = merge(var.tags, {
    Name = "${var.name}-db"
  })
}

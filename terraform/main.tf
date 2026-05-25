# ==============================================================================
# ROOT - main.tf
# Week 9: Module Composition (Activities 3, 4, 5, 7)
# ==============================================================================

locals {
  common_tags = merge(var.tags, {
    Project     = var.project_name
    Environment = terraform.workspace # Activity 8: workspace-aware tagging
    ManagedBy   = "terraform"
  })

  # Workspace-aware naming (Activity 8)
  name_prefix = "${var.project_name}-${terraform.workspace}"
}

# ==============================================================================
# Activity 3 & 4: Module Composition — custom VPC + EC2 + RDS modules
# ==============================================================================

module "network" {
  source = "./modules/vpc"

  name               = local.name_prefix
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones

  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs

  create_igw         = true
  create_nat_gateway = var.create_nat_gateway
  single_nat_gateway = true

  tags = local.common_tags
}

module "compute" {
  source = "./modules/ec2"

  name       = local.name_prefix
  vpc_id     = module.network.vpc_id # output from network module
  subnet_ids = module.network.public_subnet_ids

  instance_type = var.instance_type
  allowed_ports = var.allowed_ports
  public_key    = var.public_key

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl enable httpd
    systemctl start httpd
    echo "<h1>Week 9 - ${local.name_prefix} - $(hostname)</h1>" > /var/www/html/index.html
  EOF

  tags = local.common_tags
}

module "database" {
  source = "./modules/rds"

  name       = local.name_prefix
  vpc_id     = module.network.vpc_id
  subnet_ids = module.network.private_subnet_ids

  allowed_security_group_ids = [module.compute.security_group_id]

  engine         = "mysql"
  engine_version = "8.0"
  instance_class = "db.t3.micro"

  db_name     = var.db_name
  db_username = var.db_username
  db_password = var.db_password

  skip_final_snapshot = true
  deletion_protection = false

  tags = local.common_tags
}

# ==============================================================================
# Activity 5: Public Terraform Registry Module
# ==============================================================================

module "vpc_public" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${local.name_prefix}-public-module"
  cidr = "10.1.0.0/16"

  azs             = var.availability_zones
  public_subnets  = ["10.1.1.0/24", "10.1.2.0/24"]
  private_subnets = ["10.1.10.0/24", "10.1.20.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = merge(local.common_tags, {
    Source = "terraform-registry"
  })
}

# ==============================================================================
# Activity 7: Dynamic Security Group Rules
# ==============================================================================

resource "aws_security_group" "dynamic_web" {
  name        = "${local.name_prefix}-dynamic-web-sg"
  description = "Dynamic security group with configurable ports"
  vpc_id      = module.network.vpc_id

  dynamic "ingress" {
    for_each = var.allowed_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow port ${ingress.value}"
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-dynamic-web-sg"
  })
}

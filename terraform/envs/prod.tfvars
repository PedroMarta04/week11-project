# envs/prod.tfvars — use with: terraform workspace select prod && terraform apply -var-file=envs/prod.tfvars
project_name       = "week9"
aws_region         = "us-east-1"
vpc_cidr           = "10.4.0.0/16"
availability_zones = ["us-east-1a", "us-east-1b"]
public_subnet_cidrs  = ["10.4.1.0/24", "10.4.2.0/24"]
private_subnet_cidrs = ["10.4.11.0/24", "10.4.12.0/24"]
create_nat_gateway = true
instance_type      = "t2.micro"
allowed_ports      = [22, 80, 443]
db_name            = "proddb"
db_username        = "admin"
db_password        = "ProdPass123!"
tags               = { Owner = "student", CostCenter = "lab" }

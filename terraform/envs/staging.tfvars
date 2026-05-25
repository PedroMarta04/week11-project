# envs/staging.tfvars — use with: terraform workspace select staging && terraform apply -var-file=envs/staging.tfvars
project_name       = "week9"
aws_region         = "us-east-1"
vpc_cidr           = "10.2.0.0/16"
availability_zones = ["us-east-1a", "us-east-1b"]
public_subnet_cidrs  = ["10.2.1.0/24", "10.2.2.0/24"]
private_subnet_cidrs = ["10.2.11.0/24", "10.2.12.0/24"]
create_nat_gateway = false
instance_type      = "t3.micro"
allowed_ports      = [22, 80, 443]
db_name            = "stagingdb"
db_username        = "admin"
db_password        = "StagingPass123!"
tags               = { Owner = "student", CostCenter = "lab" }

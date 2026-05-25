# envs/dev.tfvars — use with: terraform workspace select dev && terraform apply -var-file=envs/dev.tfvars
project_name         = "week9"
aws_region           = "us-east-1"
vpc_cidr             = "10.0.0.0/16"
availability_zones   = ["us-east-1a", "us-east-1b"]
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]
create_nat_gateway   = false
instance_type        = "t3.micro"
allowed_ports        = [22, 80]
db_name              = "devdb"
db_username          = "admin"
db_password          = "DevPass123!"
tags                 = { Owner = "student", CostCenter = "lab" }

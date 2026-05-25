# ==============================================================================
# terraform.tfvars  (default — dev-like values)
# DO NOT commit real passwords to git. Use env vars or AWS Secrets Manager.
# Override per workspace: terraform apply -var-file=envs/dev.tfvars
# ==============================================================================

project_name = "week9"
aws_region   = "us-east-1"

vpc_cidr           = "10.0.0.0/16"
availability_zones = ["us-east-1a", "us-east-1b"]

public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]

create_nat_gateway = false

instance_type = "t3.micro"
allowed_ports = [22, 80, 443]

# public_key = "ssh-rsa AAAA..."   # paste your SSH public key here

db_name     = "appdb"
db_username = "admin"
db_password = "Password123!" # Change this! Or use: export TF_VAR_db_password=...

tags = {
  Owner = "student"
}

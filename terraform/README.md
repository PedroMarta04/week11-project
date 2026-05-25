# Week 9 — Advanced Terraform: Modules, Validation & Workspaces

## Project Structure

```
week9/
├── main.tf                     # Root config — composes all modules
├── variables.tf                # Input variables with validation (Activity 6)
├── outputs.tf                  # All outputs (network + compute + db)
├── provider.tf                 # AWS provider, Terraform version constraints
├── terraform.tfvars            # Default variable values (dev)
├── for_each_refactor.tf        # Activity 10: count → for_each explanation
├── envs/
│   ├── dev.tfvars              # Dev workspace values
│   ├── staging.tfvars          # Staging workspace values
│   └── prod.tfvars             # Prod workspace values
└── modules/
    ├── vpc/                    # Activity 1: VPC module
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── ec2/                    # Activity 2: EC2 module
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── rds/                    # Activity 4: RDS module
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

---

## Activities Coverage

| Activity | Description | Location |
|---|---|---|
| 1 | VPC Module | `modules/vpc/` |
| 2 | EC2 Module | `modules/ec2/` |
| 3 | Module Composition | `main.tf` — `module "network"` + `module "compute"` |
| 4 | Refactor with RDS | `modules/rds/` + `main.tf` |
| 5 | Public Registry Module | `main.tf` — `module "vpc_public"` |
| 6 | Validation + Sensitive vars | `variables.tf` |
| 7 | Dynamic Security Group | `main.tf` — `aws_security_group.dynamic_web` |
| 8 | Workspaces | `envs/*.tfvars` + workspace commands below |
| 9 | Validation Pipeline | Run sequence below |
| 10 | `count` → `for_each` | `for_each_refactor.tf` |

---

## Prerequisites

```bash
# 1. Install Terraform >= 1.5
brew install terraform         # macOS
# or download from https://developer.hashicorp.com/terraform/downloads

# 2. Configure AWS credentials
aws configure
# OR for AWS Academy Learner Lab, export the three env vars:
export AWS_ACCESS_KEY_ID=...
export AWS_SECRET_ACCESS_KEY=...
export AWS_SESSION_TOKEN=...

# 3. (Optional) Add your SSH public key to terraform.tfvars
# public_key = "ssh-rsa AAAA..."
```

---

## Quick Start (Activity 9 — Validation Pipeline)

```bash
# Format all files
terraform fmt -recursive

# Validate configuration
terraform validate

# Plan and save
terraform plan -out=tfplan

# Review the plan, then apply
terraform apply tfplan
```

---

## Activity 8 — Multi-Environment Workspaces

```bash
# Create workspaces
terraform workspace new dev
terraform workspace new staging
terraform workspace new prod

# Deploy to dev
terraform workspace select dev
terraform apply -var-file=envs/dev.tfvars

# Deploy to staging
terraform workspace select staging
terraform apply -var-file=envs/staging.tfvars

# List workspaces (active one marked with *)
terraform workspace list

# Destroy a workspace's resources when done
terraform workspace select dev
terraform destroy -var-file=envs/dev.tfvars
```

---

## Module Inputs & Outputs

### `modules/vpc`

| Input | Type | Default | Description |
|---|---|---|---|
| `name` | string | — | Resource name prefix |
| `vpc_cidr` | string | `10.0.0.0/16` | VPC CIDR block |
| `availability_zones` | list(string) | — | AZs to use |
| `public_subnet_cidrs` | list(string) | `[]` | Public subnet CIDRs |
| `private_subnet_cidrs` | list(string) | `[]` | Private subnet CIDRs |
| `create_nat_gateway` | bool | `false` | Create NAT Gateway |
| `single_nat_gateway` | bool | `false` | Single vs per-AZ NAT |

| Output | Description |
|---|---|
| `vpc_id` | VPC ID |
| `igw_id` | Internet Gateway ID |
| `public_subnet_ids` | List of public subnet IDs |
| `private_subnet_ids` | List of private subnet IDs |
| `public_route_table_id` | Public route table ID |
| `private_route_table_ids` | Private route table IDs |

### `modules/ec2`

| Input | Type | Default | Description |
|---|---|---|---|
| `name` | string | — | Resource name prefix |
| `vpc_id` | string | — | VPC to deploy into |
| `subnet_ids` | list(string) | — | Subnets (first is used) |
| `instance_type` | string | `t2.micro` | EC2 instance type |
| `allowed_ports` | list(number) | `[22,80,443]` | SG ingress ports |
| `public_key` | string | `""` | SSH public key (sensitive) |

| Output | Description |
|---|---|
| `instance_id` | EC2 instance ID |
| `public_ip` | Public IP address |
| `public_dns` | Public DNS hostname |
| `ssh_connection` | Ready-to-use SSH command |
| `security_group_id` | Attached SG ID |

### `modules/rds`

| Input | Type | Default | Description |
|---|---|---|---|
| `name` | string | — | Resource name prefix |
| `vpc_id` | string | — | VPC ID |
| `subnet_ids` | list(string) | — | Private subnet IDs |
| `db_username` | string | — | Master username (sensitive) |
| `db_password` | string | — | Master password (sensitive) |
| `engine` | string | `mysql` | DB engine |
| `instance_class` | string | `db.t3.micro` | RDS instance class |

| Output | Description |
|---|---|
| `db_endpoint` | Full connection endpoint |
| `db_host` | Hostname only |
| `db_port` | Port number |
| `security_group_id` | RDS SG ID |

---

## Cleaning Up (avoid AWS charges)

```bash
terraform workspace select dev
terraform destroy -var-file=envs/dev.tfvars -auto-approve

terraform workspace select staging
terraform destroy -var-file=envs/staging.tfvars -auto-approve
```

> **Note:** RDS instances take a few minutes to destroy. NAT Gateways and Elastic IPs also incur hourly charges — always destroy when done.

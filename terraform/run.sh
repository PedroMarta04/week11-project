#!/bin/bash
# ==============================================================================
# run.sh — Activity 9: Complete Validation Pipeline
# Usage: bash run.sh [dev|staging|prod]
# ==============================================================================

set -e

WORKSPACE=${1:-dev}
VARFILE="envs/${WORKSPACE}.tfvars"

echo "============================================"
echo " Week 9 Terraform Pipeline"
echo " Workspace : $WORKSPACE"
echo " Var file  : $VARFILE"
echo "============================================"
echo ""

# Step 1: Format
echo ">>> Step 1: terraform fmt -recursive"
terraform fmt -recursive
echo "    [OK] All files formatted."
echo ""

# Step 2: Init (downloads providers + registry module)
echo ">>> Step 2: terraform init"
terraform init
echo ""

# Step 3: Validate
echo ">>> Step 3: terraform validate"
terraform validate
echo ""

# Step 4: Select / create workspace
echo ">>> Step 4: workspace = $WORKSPACE"
terraform workspace select "$WORKSPACE" 2>/dev/null || terraform workspace new "$WORKSPACE"
echo ""

# Step 5: Plan
echo ">>> Step 5: terraform plan -out=tfplan"
terraform plan -var-file="$VARFILE" -out=tfplan
echo ""

echo "============================================"
echo " Review the plan above, then press Enter"
echo " to apply, or Ctrl+C to cancel."
echo "============================================"
read -r

# Step 6: Apply
echo ">>> Step 6: terraform apply tfplan"
terraform apply tfplan
echo ""

echo "============================================"
echo " Done! Outputs:"
echo "============================================"
terraform output

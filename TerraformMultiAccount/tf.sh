#!/usr/bin/env bash
ENV=${1:-prod}
shift || true

echo "Running Terraform in environment: $ENV"
terraform -chdir="environments/$ENV" "$@"

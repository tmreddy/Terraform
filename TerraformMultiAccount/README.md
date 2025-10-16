# Terraform Cloud Multi-Account Example

This project demonstrates:
- Terraform Cloud backend (remote state, no local .tfstate)
- Multi-account AWS setup (different creds per workspace)
- Global shared config (versions, providers, backend)
- GitOps workflow (via GitHub Actions)
- Sentinel policy enforcement

## Usage

1. **Create workspaces in Terraform Cloud:**
   - `dev`, `staging`, `prod` (each mapped to this repo)

2. **Set environment variables per workspace:**
   - `AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY` for each AWS account
   - (or use OIDC roles per account)

3. **Run locally:**
   ```bash
   ./tf.sh dev init
   ./tf.sh dev plan
   ./tf.sh dev apply
   ```

4. **Terraform Cloud:** Each workspace handles its own remote state + AWS account.


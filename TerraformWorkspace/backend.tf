terraform {
 backend "s3" {
   bucket         = "terraformworkspacestatebucket"    # replace
   key            = "workspaces/terraform.tfstate" # common prefix; per-workspace file created automatically
   region         = "us-east-1"                    # replace
   encrypt        = true
   acl            = "private"
 }
}


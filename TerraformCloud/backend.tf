terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "TerraformHandsOn"

    workspaces {
      name = "Terraform"
    }
  }
}

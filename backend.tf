terraform {
  backend "s3" {
    bucket         = "terraform2statebucket"
    key            = "env/dev/terraform.tfstate"
    region         = "us-east-1"
  } 
}


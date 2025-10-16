terraform { required_version = "~> 1.9.0" }

# Include global configs (symlink or reference via chdir)
module "vpc" {
  source = "../../modules/vpc"
  name   = "my-dev-vpc"
  cidr   = "10.30.0.0/16"
}

module "app_bucket" {
  source      = "../../modules/s3"
  bucket_name = "my-dev-app-bucket-12345"
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "bucket_arn" {
  value = module.app_bucket.bucket_arn
}

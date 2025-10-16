data "aws_vpc" "default" {
  default = true
}
data "aws_subnets" "vpc_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}
output "subnet_ids" {
  value = data.aws_subnets.vpc_subnets.ids
}
resource "aws_subnet" "example" {
  vpc_id     = data.aws_vpc.default.id
  cidr_block = "172.31.192.0/19" # You can calculate CIDR for this site by default us-east-1 has 6 subnet for each availability zone give the VPC CIDR range in Network Address block and select 8 as Number of Subnets and select 7th Subnet Address / from CIDR Notation https://www.site24x7.com/tools/ipv4-subnetcalculator.html Give valid CIDR range
}
module "ec2_instance" {
  source        = "terraform-aws-modules/ec2-instance/aws"
  name          = "single-instance"
  instance_type = "t3.micro"
  monitoring    = true
  subnet_id    = data.aws_subnets.vpc_subnets.ids[0]
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}


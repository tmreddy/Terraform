module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  name = "single-instance"
  instance_type = "t3.micro"
  monitoring    = true
  subnet_id = "subnet-0652ccac17322c686"
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}


module "web" {
  source        = "./modules/ec2"
  ami_id        = "ami-052064a798f08f0d3"
  instance_type = "t2.micro"
  instance_name = "WebServer"
}


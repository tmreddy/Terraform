# provider block
provider "aws" {
  region= "us-east-1"
}

# resource block
resource "aws_instance" "example" {
  ami = "ami-052064a798f08f0d3"
  instance_type = "t3.micro"

  tags = {
    Name = "TerraformExample"
  }
}
# output

output "public_ip" {
  value = aws_instance.example.public_ip
}


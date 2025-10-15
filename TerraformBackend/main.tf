provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform2statebucket"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
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


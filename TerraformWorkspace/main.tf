data "aws_ami" "amazon_linux" {
 most_recent = true
 owners      = ["amazon"]
 filter {
   name   = "name"
   values = ["amzn2-ami-hvm-*-x86_64-gp2"]
 }
}
resource "aws_instance" "app" {
 ami                    = data.aws_ami.amazon_linux.id
 instance_type          = var.instance_type
 tags = {
   Name      = "app-${terraform.workspace}"
   Environment = terraform.workspace
 }
}


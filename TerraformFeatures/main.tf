data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # give aws account id 
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}
resource "aws_security_group" "web_sg" {
  name = "web-sg"
  dynamic "ingress" {
    for_each = toset([22, 80, 443])
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}
resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = "cloud"
  vpc_security_group_ids = [aws_security_group.web_sg.id]
}


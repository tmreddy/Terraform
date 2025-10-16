variable "name" {}
variable "cidr" { default = "10.0.0.0/16" }

resource "aws_vpc" "this" {
  cidr_block = var.cidr
  tags = { Name = var.name }
}

output "vpc_id" { value = aws_vpc.this.id }

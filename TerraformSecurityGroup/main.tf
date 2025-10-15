variable "ingress_rules" {
  default = [
    { port = 22, description = "SSH" },
    { port = 80, description = "HTTP" },
    { port = 443, description = "HTTPS" }
  ]
}
resource "aws_security_group" "web_sg" {
  name = "web-sg"
  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}


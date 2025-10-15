variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region to deploy resources"
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "EC2 instance type"
  validation {
    condition     = contains(["t2.micro", "t2.small"],   var.instance_type)
    error_message = "Instance type must be t2.micro or t2.small."
  }
}

variable "ami" {
  type        = string
  default     = "ami-052064a798f08f0d3"
  description = "Amazon Machine Image"
}


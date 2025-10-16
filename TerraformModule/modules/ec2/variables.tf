variable "ami_id" {
  description = "AMI ID to use for the EC2 instance"
  type        = string
}
variable "instance_type" {
  description = "Instance type"
  type        = string
}
variable "instance_name" {
  description = "Tag name for the EC2 instance"
  type        = string
}


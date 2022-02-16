# Common
variable "prefix" {
  default     = "terraform-test-yoshimura"
  description = "project name given as a prefix"
}

# VPC
variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "the CIDR block for the VPC"
}

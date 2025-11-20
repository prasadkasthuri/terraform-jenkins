#variable "vpc_cidr_block" {}

variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type = string

  }

  variable "vpc_name" {
    description = "Name of the VPC"
    type = string
  }

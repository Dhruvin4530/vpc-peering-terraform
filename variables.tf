# VPC A CIDR
variable "demo-vpc-a-cidr" {
  type        = string
  description = "CIDR of VPC A"
}

# VPC B CIDR
variable "demo-vpc-b-cidr" {
  type        = string
  description = "CIDR of VPC B"
}

# Subnet A CIDR
variable "demo-subnet-a-cidr" {
  type        = string
  description = "CIDR of demo subnet A"
}

# Subnet B CIDR
variable "demo-subnet-b-cidr" {
  type        = string
  description = "CIDR of demo subnet B"
}

# Region
variable "region" {
  type        = string
  description = "Region"
}
variable "environment" {
  description = "This is mainly used to set various identifiers and prefixes/suffixes for your project"
  default = "production"
}

variable "private_subnets" {
  description = "IP prefix of private subnets for VPC-only routing"
  default = "10.11.0.0/20,10.11.16.0/20"
}

variable "public_subnets" {
  description = "IP prefix of public subnets for internet gateway routing"
  default = "10.11.32.0/20,10.11.48.0/20"
}

variable "region" {
  type = string
  default = "us-east-1"
}

variable "azs" {
  type        = string
  description = "Availability Zones (AZs) for your project"
  default = "us-east-1a,us-east-1b"
}

variable "enable_dns_hostnames" {
  description = "Set to true if you want to use private DNS within the VPC"
  default     = true
}

variable "enable_dns_support" {
  description = "Set to true if you want to enable DNS support within the VPC"
  default     = true
}

variable "vpc_cidr" {
  type        = string
  description = "IP prefix of the main VPC"
  default = "10.11.0.0/16"
}

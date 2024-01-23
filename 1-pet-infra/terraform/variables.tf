# AWS Configuration Variables
variable "region" {
  default     = "us-east-1"
  description = "Name of the AWS region"
  type        = string
}

variable "aws_profile" {
  default     = "default"
  description = "Name of the AWS Profile"
  type        = string
}

variable "env" {
  default     = "Dev"
  description = "Name of the environment"
  type        = string
}

# Virtual Private Cloud (VPC) Variables
variable "cidr_block" {
  default = "10.0.0.0/16" 
  type    = string
}

variable "web_vpc_tenancy" {
  default = "default"
  type    = string
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones"
}

variable "public_subnet_cidr_blocks" {
  type        = list(string)
  description = "List of Public Subnet Blocks"
}

variable "private_subnet_cidr_blocks" {
  type        = list(string)
  description = "List of Private Subnet Blocks"
}

# Elastic Cloud Compute (EC2) Variables
variable "ami" {
  default     = "ami-053b0d53c279acc90"
  description = "Name of the software image"
  type        = string
}

variable "type" {
  default     = "t3.medium"
  description = "Name of the instance type"
  type        = string
}

variable "az" {
  default     = "us-east-1a"
  description = "Name of AZs"
  type        = string
}

variable "az2" {
  default     = "us-east-1b"
  description = "Name of AZs"
  type        = string
}

variable "az3" {
  default     = "us-east-1b"
  description = "Name of AZs"
  type        = string
}

# Amazon RDS Variables
variable "identifier" {
  type        = string
  default     = "docupet"
  description = "Name of your DB cluster"
}

variable "instance_class" {
  type        = string
  default     = "db.t3.micro"
  description = "type of storage class"
}

variable "db_storage" {
  type    = number
  default = "20"
}

variable "storage_type" {
  type    = string
  default = "gp2"
}

variable "engine" {
  type        = string
  default     = "mysql"
  description = "Name of database engine"
}

variable "engine_version" {
  type    = number
  default = "5.7"
}

variable "username" {
  description = "Name of the user"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "RDS root user password"
  type        = string
  default     = "Password0123"
  sensitive   = true
}

# Key Pair Variables
variable "key_name" {
  default     = "web-test"
  description = "Name of Key-Pair"
}

# User home directory Variable
variable "home_dir" {
  default     = ""
  description = "Name of the user home directory"
  type        = string
}

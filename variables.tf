#Global
variable "aws_region" {
    default = "ap-northeast-2"
    type = string
}

variable "aws_default_name" {
    default = "k5s-EKS"
    type = string
}

#VPC Configuration
variable "aws_vpc_cidr_block" {
    default = "10.0.0.0/16"
    type = string
}

variable "aws_vpc_public_subnets" {
    default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
    type = list(string)
}

variable "aws_vpc_private_subnets" {
    default = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
    type = list(string)
}

variable "aws_azs"  {
    default = ["ap-northeast-2a", "ap-northeast-2b", "ap-northeast-2c"]
    type = list(string)
}
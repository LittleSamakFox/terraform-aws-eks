#aws provider init
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.8.0"
    }
  }
}

# Configure the AWS Provider
provider "aws"  {
    region = var.aws_region
}

#pem key 가져와서 aws 키페어에 등록
resource "aws_key_pair" "k5s_key" {
    key_name = "goorm_project_k5s_public"
    public_key = file("~/.ssh/goorm_project_k5s_public.pem")
}
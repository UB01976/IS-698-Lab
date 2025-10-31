terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "random_id" "suffix" {
  byte_length = 4
}

# VPC
module "vpc" {
  source         = "./modules/vpc"
  vpc_cidr       = "10.0.0.0/16"
  public_subnet  = "10.0.1.0/24"
  private_subnet = "10.0.2.0/24"
  az             = "us-east-1a"
}

# Bastion Host (public subnet)
module "bastion" {
  source        = "./modules/bastion"
  ami           = "ami-052064a798f08f0d3"
  instance_type = "t3.micro"
  subnet_id     = module.vpc.public_subnet_id
  vpc_id        = module.vpc.vpc_id
  key_name      = "shashank-puppala-bastion-host"
}

# Private EC2 (web server)
module "ec2" {
  source        = "./modules/ec2"
  ami           = "ami-052064a798f08f0d3"
  instance_type = "t3.micro"
  subnet_id     = module.vpc.private_subnet_id
  vpc_id        = module.vpc.vpc_id
  key_name      = "shashank-puppala-linux-private-keypair"
}

# S3 Bucket
module "S3" {
  source      = "./modules/S3"
  bucket_name = "shashank-puppala-static-${random_id.suffix.hex}"
}

# DynamoDB Table
module "dynamodb" {
  source     = "./modules/dynamodb"
  table_name = "shashank-puppala-userlogins"
}

# Outputs
output "bastion_public_ip" {
  value = module.bastion.bastion_public_ip
}

output "private_ec2_ip" {
  value = module.ec2.private_ip
}



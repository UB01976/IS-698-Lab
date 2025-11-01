terraform {
  backend "s3" {
    bucket         = "terraform-state-shashank-puppala-bucket"
    key            = "terraform/state.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}

provider "aws" {
  region = "us-east-1"
}

# Sample resource to test the remote state 
resource "aws_instance" "example" {
  ami           = "ami-0bdd88bd06d16ba03"
  instance_type = "t3.micro"

  tags = {
    Name = "Terraform-Test-Instance-1"
  }
}

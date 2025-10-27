provider "aws" {
   region = "us-east-1"
}

resource "aws_instance" "my_ec2" {
  ami    = "ami-052064a798f08f0d3"
  instance_type = "t3.micro"
  key_name = "shashank-puppala-lab6-keypair"
  tags = {
    Name = "TerraformEC2-2"
	}
} 

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-2"
}
resource "aws_instance" "web" {
  ami           = "ami-0835374e611a23aa7"
  instance_type = "t2.micro"
  key_name = "ec2"
  security_groups = ["launch-wizard-2"]
  get_password_data = "true"
  connection {
    type = "winrm"
    user = "Administrator"
    port = 5986
    password = "${rsadecrypt(self.password_data, file("ec.pem"))}"
    host = "${self.private_ip}"
  }
  provisioner "local-exec" {
    command = "echo ${self.private_ip} > hosts.txt"
  }
  provisioner "remote-exec" {
    inline = [
         "powershell -ExecutionPolicy Unrestricted -File winrm.ps1"
        ]
  }
}

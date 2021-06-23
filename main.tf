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
variable "admin_password" {
  type        = string
  description = "Enter the password for Windows"
}
resource "aws_instance" "web" {
  ami           = "ami-0835374e611a23aa7"
  instance_type = "t2.micro"
  key_name = "ec2"
  security_groups = ["launch-wizard-2"]
  connection {
    type = "winrm"
    user = "Administrator"
    password = "${var.admin_password}"
    host = "${self.private_ip}"
  }
  provisioner "local-exec" {
    command = "echo ${self.public_ip} > hosts.txt"
  }
  provisioner "remote-exec" {
    inline = [
         "powershell -ExecutionPolicy Unrestricted -File winrm.ps1"
        ]
  }
}

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
  user_data = "${file("userdata.txt")}"
  provisioner "local-exec" {
    command = "echo [win] > hosts.txt"
  }
  provisioner "local-exec" {
    command = "echo ${self.public_ip} >> hosts.txt"
  }
  provisioner "local-exec" {
    command =  "echo [win:vars] >> hosts.txt"
  }
    provisioner "local-exec" {
    command =  "echo 'ansible_user = \"Administrator\"' >> hosts.txt"
  }
    provisioner "local-exec" {
    command =  "echo ansible_password = '${rsadecrypt(self.password_data, file("ec.pem"))}' >> hosts.txt"
  }
    provisioner "local-exec" {
    command =  "echo 'ansible_connection = \"winrm\"' >> hosts.txt"
  }
    provisioner "local-exec" {
    command =  "echo ansible_winrm_server_cert_validation = ignore >> hosts.txt"
  }
}

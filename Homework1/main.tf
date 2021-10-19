variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "private_key_path" {}
variable "key_name" {}

variable "profile" {}
variable "region" {
  default = "us-east-1"
}


locals {
  common_tags = {
    Owner   = "Yossi",
    Purpose = "whiskey"
  }

}
provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.region
}


resource "aws_default_vpc" "default" {

}

data "aws_ami" "aws-linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


resource "aws_security_group" "allow_ssh" {
  name        = "nginx"
  description = "Allow ports for nginx"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "whiskey1" {
  ami                    = data.aws_ami.aws-linux.id
  instance_type          = "t3.micro"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file(var.private_key_path)
  }

  ebs_block_device {
          device_name           =  "/dev/sda1"
          encrypted             = true
          volume_size           = 10
          volume_type           = "gp2" 
  }
  root_block_device {
          volume_size           = 8
          volume_type           = "gp2"
  }

  tags = merge(local.common_tags, { Name = "whiskey1" })

  provisioner "remote-exec" {
    inline = [
      "sudo yum install nginx -y",
      "sudo service nginx start",
      "sudo rm /usr/share/nginx/html/index.html",
      "echo '<html><head><title>Welcome to Grandpas Whiskey</title></head><body style=\"background-color:#1F778D\"><p style=\"text-align: center;\"><span style=\"color:#FFFFFF;\"><span style=\"font-size:28px;\">Welcome to Grandpas Whiskey</span></span></p></body></html>' | sudo tee /usr/share/nginx/html/index.html"
    ]
  }
}

resource "aws_instance" "whiskey2" {
  ami                    = data.aws_ami.aws-linux.id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  key_name               = var.key_name

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file(var.private_key_path)
  }


  ebs_block_device {
          device_name           =  "/dev/sda1"
          encrypted             = true
          volume_size           = 10
          volume_type           = "gp2" 
  }
  root_block_device {
          volume_size           = 8
          volume_type           = "gp2"
  }

  tags = merge(local.common_tags, { Name = "whiskey2" })

  provisioner "remote-exec" {
    inline = [
      "sudo yum install nginx -y",
      "sudo service nginx start",
      "sudo rm /usr/share/nginx/html/index.html",
      "echo '<html><head><title>Welcome to Grandpas Whiskey</title></head><body style=\"background-color:#1F778D\"><p style=\"text-align: center;\"><span style=\"color:#FFFFFF;\"><span style=\"font-size:28px;\">Welcome to Grandpas Whiskey</span></span></p></body></html>' | sudo tee /usr/share/nginx/html/index.html"
    ]
  }
}

output "aws_instance_public_dns" {
  value = aws_instance.whiskey1.public_dns
}

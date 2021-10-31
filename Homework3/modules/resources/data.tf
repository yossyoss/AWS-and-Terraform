data "aws_availability_zones" "available" {}

data "aws_ami" "ubuntu-18" {
  most_recent = true
//  owners      = [var.ubuntu_account_number]
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}

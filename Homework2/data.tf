##################################################################################
# DATA
##################################################################################

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "aws-linux" {
  most_recent = true
  owners      = [var.ubuntu_account_number]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}

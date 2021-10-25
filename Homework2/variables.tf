##################################################################################
# VARIABLES
##################################################################################
variable "private_key_path" {
  type    = string
  default= "../opschool.pem"
}
variable "key_name" {
  type    = string
  default = "opschool"
}

variable "aws_region" {
  default = "us-east-1"
  type    = string
}
variable "instance_type" {
  description = "The type of the nginx EC2"
  type        = string
  default     = "t2.micro"
}

variable network_address_space {
  default = "10.0.0.0/16"
}
variable "subnet1_address_space" {
  default = "10.1.0.0/24"
}
variable "subnet2_address_space" {
  default = "10.1.1.0/24"
}

variable "number_of_nginx_instances" {
  description = "The number of nginx instances to create"
  default = "2"
}
variable "public_subnet_count" {
  description = "The number of public subnet"
  default = 2
}
variable "private_subnet_count" {
  description = "The number of private subnet"
  default = 2
}
variable "ubuntu_account_number" {
  default = "099720109477"
  type    = string
}

variable "owner_tag" {
  description = "The owner tag will be applied to every resource in the project through the 'default variables' feature"
  default = "Yossi"
  type    = string
}
variable "purpose_tag" {
  default = "Whiskey"
  type    = string
}

variable "name_tag" {
  default = "Nginx"
  type    = string
}

##################################################################################
# LOCALS
##################################################################################

locals {
  common_tags = {
    Purpose = "whiskey"
  }
  public_subnets_addresses = [
    "10.0.10.0/24",
    "10.0.11.0/24",
  ]
  private_subnets_addresses = [
    "10.0.1.0/24",
    "10.0.2.0/24",
  ]



}
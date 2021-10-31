variable "region_name" {
  type    = string
  default = "us-east-1"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "availability_zones_count" {
  type    = number
  default = 2
}

variable "instance_count" {
  type    = number
  default = 2
}

variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "owner_tag" {
  type    = string
  default = "Yossi"
}

variable "purpose_tag" {
  type    = string
  default = "Whiskey"
}

# SUBNETS
resource "aws_subnet" "public_subnets" {
  count                   = var.availability_zones_count
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 8, 1 + count.index)
  availability_zone_id    = data.aws_availability_zones.available.zone_ids[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.purpose_tag}-public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnets" {
  count                = var.availability_zones_count
  vpc_id               = aws_vpc.vpc.id
  cidr_block           = cidrsubnet(aws_vpc.vpc.cidr_block, 8, 101 + count.index)
  availability_zone_id = data.aws_availability_zones.available.zone_ids[count.index]

  tags = {
    Name = "${var.purpose_tag}-private-subnet-${count.index + 101}"
  }
}

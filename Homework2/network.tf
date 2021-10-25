# NETWORKING #
resource "aws_vpc" "vpc" {
  cidr_block = var.network_address_space
  tags = merge(local.common_tags, { Name = "vpc" })
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(local.common_tags, { Name = "igw" })
}
/* Elastic IP for NAT */
resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.igw]
}
/* NAT */
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = element(aws_subnet.public_subnet.*.id, 0)
  depends_on    = [aws_internet_gateway.igw]
  tags = merge(local.common_tags, { Name = "nat-gw" })
}

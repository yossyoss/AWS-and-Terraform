resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.purpose_tag}_internet_gateway"
  }
}

########################
# Internet NAT Gateway
########################

resource "aws_eip" "internet_nat_gateway_eips" {
  count = length(aws_subnet.public_subnets[*].id)
  tags = {
    Name = "${var.purpose_tag}-eip-internet-nat-gateway-${count.index}"
  }

  # EIP may require IGW to exist prior to association. 
  # Use depends_on to set an explicit dependency on the IGW.
  depends_on = [aws_internet_gateway.internet_gateway]
}

resource "aws_nat_gateway" "internet_nat_gateways" {
  count         = length(aws_subnet.public_subnets[*].id)
  allocation_id = aws_eip.internet_nat_gateway_eips[count.index].id
  subnet_id     = aws_subnet.public_subnets[count.index].id

  tags = {
    Name = "${var.purpose_tag}-internet-nat-gateway-${count.index}"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.internet_gateway]
}
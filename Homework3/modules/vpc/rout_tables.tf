//resource "aws_default_route_table" "default_route_table" {
//  default_route_table_id = aws_vpc.vpc.default_route_table_id
//
//  tags = {
//    Name = "${var.purpose_tag}-default-route-table"
//  }
//}

##########
# Public
##########

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.purpose_tag}-public-route-table"
  }
}

resource "aws_route" "route_to_internet_gateway" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway.id
}


resource "aws_route_table_association" "public_route_table_association" {
  count          = length(aws_subnet.public_subnets[*].id)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}


##########
# Private
##########

resource "aws_route_table" "private_route_tables" {
  count  = var.availability_zones_count
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.purpose_tag}-private-route-table-${count.index + 1}"
  }
}

resource "aws_route" "route_to_internet_nat_gateway" {
  count                  = length(aws_route_table.private_route_tables[*].id)
  route_table_id         = aws_route_table.private_route_tables[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.internet_nat_gateways[count.index].id
}

resource "aws_route_table_association" "private_route_table_association" {
  count          = length(aws_subnet.private_subnets[*].id)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_route_tables[count.index].id
}




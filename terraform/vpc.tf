resource "aws_vpc" "ipv6_vpc" {
  cidr_block       = null
  assign_generated_ipv6_cidr_block = true
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "ipv6-only"
  }
}

resource "aws_subnet" "ipv6_subnet" {
  count                  = 2
  vpc_id                 = aws_vpc.ipv6_vpc.id
  ipv6_cidr_block        = cidrsubnet(aws_vpc.ipv6_vpc.ipv6_cidr_block, 8, count.index)
  availability_zone      = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "ipv6-only-subnet-${count.index}"
  }
}

data "aws_availability_zones" "available" {}

resource "aws_internet_gateway" "ipv6_igw" {
  vpc_id = aws_vpc.ipv6_vpc.id

  tags = {
    Name = "ipv6-igw"
  }
}

resource "aws_route_table" "ipv6_route_table" {
  vpc_id = aws_vpc.ipv6_vpc.id

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.ipv6_igw.id
  }

  tags = {
    Name = "ipv6-route-table"
  }
}

resource "aws_route_table_association" "ipv6_rta" {
  count          = length(aws_subnet.ipv6_subnet)
  subnet_id      = aws_subnet.ipv6_subnet[count.index].id
  route_table_id = aws_route_table.ipv6_route_table.id
}
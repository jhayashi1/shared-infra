resource "aws_vpc" "ipv6_only_vpc" {
  assign_generated_ipv6_cidr_block = true
  enable_dns_support               = true
  enable_dns_hostnames             = true

  tags = {
    Name = "ipv6-only"
  }
}

resource "aws_subnet" "ipv6_only_subnet" {
  vpc_id                          = aws_vpc.ipv6_only_vpc.id
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.ipv6_only_vpc.ipv6_cidr_block, 8, 0)
  assign_ipv6_address_on_creation = true

  tags = {
    Name = "ipv6-only-subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.ipv6_only_vpc.id

  tags = {
    Name = "ipv6-only-igw"
  }
}

resource "aws_route_table" "ipv6_route_table" {
  vpc_id = aws_vpc.ipv6_only_vpc.id

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "ipv6-only-route-table"
  }
}

resource "aws_route_table_association" "ipv6_route_assoc" {
  subnet_id      = aws_subnet.ipv6_only_subnet.id
  route_table_id = aws_route_table.ipv6_route_table.id
}

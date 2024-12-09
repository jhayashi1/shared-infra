resource "aws_vpc" "ipv6_only" {
  cidr_block                       = "10.0.0.0/16"
  assign_generated_ipv6_cidr_block = true
  enable_dns_support               = true
  enable_dns_hostnames             = true

  tags = {
    Name = "ipv6-only"
  }
}

resource "aws_internet_gateway" "ipv6_igw" {
  vpc_id = aws_vpc.ipv6_only.id

  tags = {
    Name = "ipv6-igw"
  }
}

resource "aws_subnet" "ipv6_a" {
  vpc_id           = aws_vpc.ipv6_only.id
  cidr_block       = "10.0.1.0/24"
  ipv6_cidr_block  = cidrsubnet(aws_vpc.ipv6_only.ipv6_cidr_block, 8, 0)
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"

  tags = {
    Name = "ipv6-only-subnet-a"
  }
}

resource "aws_subnet" "ipv6_b" {
  vpc_id           = aws_vpc.ipv6_only.id
  cidr_block       = "10.0.2.0/24"
  ipv6_cidr_block  = cidrsubnet(aws_vpc.ipv6_only.ipv6_cidr_block, 8, 1)
  map_public_ip_on_launch = true
  availability_zone = "us-east-1b"

  tags = {
    Name = "ipv6-only-subnet-b"
  }
}

resource "aws_route_table" "ipv6_route_table" {
  vpc_id = aws_vpc.ipv6_only.id

  route {
    ipv6_cidr_block = "::/0"
    gateway_id = aws_internet_gateway.ipv6_igw.id
  }

  tags = {
    Name = "ipv6-route-table"
  }
}

resource "aws_route_table_association" "ipv6_subnet_a" {
  subnet_id      = aws_subnet.ipv6_a.id
  route_table_id = aws_route_table.ipv6_route_table.id
}

resource "aws_route_table_association" "ipv6_subnet_b" {
  subnet_id      = aws_subnet.ipv6_b.id
  route_table_id = aws_route_table.ipv6_route_table.id
}
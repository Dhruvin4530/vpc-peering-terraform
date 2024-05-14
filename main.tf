# Using data source to get all Avalablility Zones in region
data "aws_availability_zones" "available_zones" {}

# Demo VPC A
resource "aws_vpc" "demo-vpc-a" {
  cidr_block = var.demo-vpc-a-cidr

  tags = {
    Name = "demo-vpc-a"
  }
}

# Demo VPC B
resource "aws_vpc" "demo-vpc-b" {
  cidr_block = var.demo-vpc-b-cidr

  tags = {
    Name = "demo-vpc-b"
  }
}

# Subnet in Demo VPC A
resource "aws_subnet" "demo-subnet-a" {
  vpc_id            = aws_vpc.demo-vpc-a.id
  cidr_block        = var.demo-subnet-a-cidr
  availability_zone = data.aws_availability_zones.available_zones.names[0]

  tags = {
    Name = "Public Subnet A"
  }
}

# Subnet in Demo VPC B
resource "aws_subnet" "demo-subnet-b" {
  vpc_id            = aws_vpc.demo-vpc-b.id
  cidr_block        = var.demo-subnet-b-cidr
  availability_zone = data.aws_availability_zones.available_zones.names[1]

  tags = {
    Name = "Public Subnet B"
  }
}

# Peering connection
resource "aws_vpc_peering_connection" "vpc_peering" {
  vpc_id      = aws_vpc.demo-vpc-a.id
  peer_vpc_id = aws_vpc.demo-vpc-b.id
}

# Peering connection acceptor
resource "aws_vpc_peering_connection_accepter" "vpc_peering_accepter" {
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
  auto_accept               = true
}

# Route tables
resource "aws_route_table" "demo-route-table-a" {
  vpc_id = aws_vpc.demo-vpc-a.id
}

resource "aws_route_table" "demo-route-table-b" {
  vpc_id = aws_vpc.demo-vpc-b.id
}

# Create internet gateway
resource "aws_internet_gateway" "demo-igw" {
  vpc_id = aws_vpc.demo-vpc-a.id
}

# Create routes in route tables for VPC peering
resource "aws_route" "demo-route-a" {
  route_table_id            = aws_route_table.demo-route-table-a.id
  destination_cidr_block    = aws_vpc.demo-vpc-b.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
}

resource "aws_route" "route2" {
  route_table_id            = aws_route_table.demo-route-table-b.id
  destination_cidr_block    = aws_vpc.demo-vpc-a.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
}

# Associate internet gateway with VPC route table
resource "aws_route" "route_to_internet" {
  route_table_id         = aws_route_table.demo-route-table-a.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.demo-igw.id
}
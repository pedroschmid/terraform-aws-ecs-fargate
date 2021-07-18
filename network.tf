# VPC #
resource "aws_vpc" "this" {
  cidr_block           = var.VPC_CIDR_BLOCK
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    "Name" = "vpc-${var.ENVIRONMENT}"
  }
}

# Public subnets
resource "aws_subnet" "public" {
  count = length(var.PUBLIC_SUBNETS_CIDR)

  cidr_block        = element(var.PUBLIC_SUBNETS_CIDR, count.index)
  availability_zone = element(var.AVAILABILITY_ZONES, count.index)
  vpc_id            = aws_vpc.this.id

  tags = {
    "Name" = "public-subnet-${element(var.AVAILABILITY_ZONES, count.index)}-${var.ENVIRONMENT}"
  }
}

# Private subnets
resource "aws_subnet" "private" {
  count = length(var.PRIVATE_SUBNETS_CIDR)

  cidr_block        = element(var.PRIVATE_SUBNETS_CIDR, count.index)
  availability_zone = element(var.AVAILABILITY_ZONES, count.index)
  vpc_id            = aws_vpc.this.id

  tags = {
    "Name" = "private-subnet-${element(var.AVAILABILITY_ZONES, count.index)}-${var.ENVIRONMENT}"
  }
}

# Route tables for the subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = {
    "Name" = "public-route-table-${var.ENVIRONMENT}"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  tags = {
    "Name" = "private-route-table-${var.ENVIRONMENT}"
  }
}

# Associating route tables to subnets
resource "aws_route_table_association" "public" {
  count = length(var.PUBLIC_SUBNETS_CIDR)

  route_table_id = aws_route_table.public.id
  subnet_id      = element(aws_subnet.public.*.id, count.index)
}

resource "aws_route_table_association" "private" {
  count = length(var.PRIVATE_SUBNETS_CIDR)

  route_table_id = aws_route_table.private.id
  subnet_id      = element(aws_subnet.private.*.id, count.index)
}

# Internet gateway
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = { "Name" = "igw-${var.ENVIRONMENT}" }
}

# Elastic IP
resource "aws_eip" "this" {
  vpc        = true
  depends_on = [aws_internet_gateway.this]

  tags = { "Name" = "eip-${var.ENVIRONMENT}" }
}

# NAT gateway
resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.this.id
  subnet_id     = element(aws_subnet.public.*.id, 0)
  depends_on    = [aws_eip.this]

  tags = { "Name" = "nat-${var.ENVIRONMENT}" }
}

# Routes
resource "aws_route" "igw" {
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.this.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route" "nat" {
  route_table_id         = aws_route_table.private.id
  nat_gateway_id         = aws_nat_gateway.this.id
  destination_cidr_block = "0.0.0.0/0"
}
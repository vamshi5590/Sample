provider "aws" {
  access_key = "var.access_key"
  secret_key = "var.secret_key"
  region = "var.region"
}

#Virtual Private Cloud
resource "aws_vpc" "main" {
  cidr_block = "${var.cidr_vpc}"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.project_name}${var.env}"
      }
}
# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.project_name}${var.env}"
      }
}
resource "aws_route_table" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "igw-${var.project_name}${var.env}"
      }
}
resource "aws_route" "igw" {
  route_table_id = aws_route_table.igw.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.main.id
}
# Network Gateway
resource "aws_route_table" "ngw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "ngw-${var.project_name}${var.env}"
      }
}
resource "aws_route" "ngw" {
  route_table_id = aws_route_table.ngw.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.main1.id
}
#EIP Assign for NAT Gateway
resource "aws_eip" "nat" {
  vpc = true
}
resource "aws_nat_gateway" "main1" {
  allocation_id = aws_eip.nat.id
  subnet_id = aws_subnet.private-us-east-2a.id
  tags = {
    Name = "${var.project_name}${var.env}"
      }
}
resource "aws_nat_gateway" "main2" {
  allocation_id = aws_eip.nat.id
  subnet_id = aws_subnet.private-us-east-2b.id
  tags = {
    Name = "${var.project_name}${var.env}"
      }
}
#### public- Subnet 2a
resource "aws_subnet" "public-us-east-2a" {
  vpc_id = aws_vpc.main.id
  cidr_block = "var.public_subnet_2a"
  availability_zone_id = "use2-az1"
  tags = {
    Name = "public-us-east-2a-${var.project_name}${var.env}"
      }
}
resource "aws_route_table_association" "public-us-east-2a" {
  subnet_id = aws_subnet.public-us-east-2a.id
  route_table_id = aws_route_table.igw.id
}
#### public Subnet- 2b
resource "aws_subnet" "public-us-east-2b" {
  vpc_id = aws_vpc.main.id
  cidr_block = "var.public_subnet_2b"
  availability_zone_id = "use2-az2"
  tags = {
   Name = "public-us-east-2b-${var.project_name}${var.env}"
     }
}
resource "aws_route_table_association" "public-us-east-2b" {
  subnet_id = aws_subnet.public-us-east-2b.id
  route_table_id = aws_route_table.igw.id
}
#### private Subnet - 2a
resource "aws_subnet" "private-us-east-2a" {
  vpc_id = aws_vpc.main.id
  cidr_block = "var.private_subnet_2a"
  availability_zone_id = "use2-az1"
  tags = {
    Name = "private-us-east-2a-${var.project_name}${var.env}"
      }
}
resource "aws_route_table_association" "private-us-east-2a" {
  subnet_id = aws_subnet.private-us-east-2a.id
  route_table_id = aws_route_table.ngw.id
}
#### private Subnet -2b
resource "aws_subnet" "private-us-east-2b" {
  vpc_id = aws_vpc.main.id
  cidr_block = "private_subnet_2b"
  availability_zone_id = "use2-az2"
  tags = {
    Name = "private-us-east-2b-${var.project_name}${var.env}"
      }
}
resource "aws_route_table_association" "private-us-east-2b" {
  subnet_id = aws_subnet.private-us-east-2b.id
  route_table_id = aws_route_table.ngw.id
}
# Security-Group
resource "aws_security_group" "appserver" {
  name = "${var.project_name}${var.env}-appserver"
  description = "Application server ${var.env}"
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.project_name}${var.env}"
  }
}

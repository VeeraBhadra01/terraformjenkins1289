provider "aws" {
  region = var.region
}


#Create a VPC 
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "main-vpc"
  }

}

# Create internet gateway
resource "aws_internet_gateway" "igw-main" {
    vpc_id = aws_vpc.main.id

    tags = {
      Name = "igw-main"
    }
  
}

#Create a public subnet
resource "aws_subnet" "public-subnet" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.public_subnet_cidr
    map_public_ip_on_launch = true

    tags = {
      Name = "public-web"
    }

  
}

#Create a route table
resource "aws_route_table" "public-route" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw-main.id
    }

    tags = {
      Name = "main-public-route"
    }
  
}

#Association route table with subnet.
resource "aws_route_table_association" "public-subnet-association" {
    subnet_id = aws_subnet.public-subnet.id
    route_table_id = aws_route_table.public-route.id
  
}
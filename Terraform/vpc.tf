# Create Vpc
resource "aws_vpc" "main-vpc" {
  cidr_block       = "10.1.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "main-vpc"
  }
}

# Create subnet
resource "aws_subnet" "main-public-subnet-2" {
  vpc_id                  = aws_vpc.main-vpc.id
  cidr_block              = "10.1.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1a"

  tags = {
    Name = "public-subnet-1"
  }
}

resource "aws_subnet" "main-public-subnet-1" {
  vpc_id                  = aws_vpc.main-vpc.id
  cidr_block              = "10.1.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1b"

  tags = {
    Name = "public-subnet-2"
  }
}

# Create Internet gateway
resource "aws_internet_gateway" "main-gw" {
  vpc_id = aws_vpc.main-vpc.id

  tags = {
    Name = "main-gw"
  }
}

# Create Route table
resource "aws_route_table" "main-public-rtb" {
  vpc_id = aws_vpc.main-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-gw.id
  }
  tags = {
    Name = "main-rtb"
  }
}

# Create route table assoication
resource "aws_route_table_association" "main-pub-assoication-1" {
  subnet_id      = aws_subnet.main-public-subnet-1.id
  route_table_id = aws_route_table.main-public-rtb.id
}

resource "aws_route_table_association" "main-pub-assoication-2" {
  subnet_id      = aws_subnet.main-public-subnet-2.id
  route_table_id = aws_route_table.main-public-rtb.id
}


module "sgs" {
  source = "./sg_eks"
  vpc_id = aws_vpc.main-vpc.id
}

module "eks" {
  source     = "./eks"
  vpc_id     = aws_vpc.main-vpc.id
  subnet_ids = [aws_subnet.main-public-subnet-1.id, aws_subnet.main-public-subnet-2.id]
  sg_ids     = module.sgs.security_group_public
}
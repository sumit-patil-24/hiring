provider "aws" {
  region = var.aws_region
}

//-----------------------------
//VPC
//-----------------------------

resource "aws_vpc" "project_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = { Name = "project-vpc" }
}

//-----------------------------
//Internet Gateway
//-----------------------------

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.project_vpc.id

  tags = { Name = "project-igw" }
}

//-----------------------------
//Public Subnet
//-----------------------------

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.project_vpc.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = { Name = "public-subnet" }
}

//-----------------------------
//Private Subnet
//-----------------------------

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.project_vpc.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.availability_zone

  tags = { Name = "private-subnet" }
}

//-----------------------------
//Elastic IP for NAT Gateway
//-----------------------------

resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = { Name = "project-nat-eip" }
}

//-----------------------------
//NAT Gateway
//-----------------------------

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id
  depends_on    = [aws_internet_gateway.igw]

  tags = { Name = "project-nat-gateway" }
}

//-----------------------------
//Public Route Table
//-----------------------------

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.project_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = { Name = "public-route-table" }
}

//-----------------------------
//Private Route Table
//-----------------------------

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.project_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = { Name = "private-route-table" }
}

//-----------------------------
//Route Table Associations
//-----------------------------

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}

//-----------------------------
//Security Group - API VM
//-----------------------------

resource "aws_security_group" "api_sg" {
  name        = "api-sg"
  description = "Security group for API VM"
  vpc_id      = aws_vpc.project_vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress {
    description = "Public HTTP API"
    from_port   = 3111
    to_port     = 3111
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "iii engine websocket"
    from_port   = 49134
    to_port     = 49134
    protocol    = "tcp"
    cidr_blocks = [var.private_subnet_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "api-sg" }
}

//-----------------------------
//Security Group - Inference VM
//-----------------------------

resource "aws_security_group" "inference_sg" {
  name        = "inference-sg"
  description = "Security group for inference VM"
  vpc_id      = aws_vpc.project_vpc.id

  ingress {
    description     = "SSH from API VM"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.api_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "inference-sg" }
}

//-----------------------------
//API VM
//-----------------------------

resource "aws_instance" "api_vm" {
  ami                         = var.ami_id
  instance_type               = var.api_instance_type
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.api_sg.id]
  key_name                    = var.key_pair_name
  associate_public_ip_address = true

  tags = { Name = "api-vm" }
}

//-----------------------------
//Inference VM
//-----------------------------

resource "aws_instance" "inference_vm" {
  ami                    = var.ami_id
  instance_type          = var.inference_instance_type
  subnet_id              = aws_subnet.private_subnet.id
  vpc_security_group_ids = [aws_security_group.inference_sg.id]
  key_name               = var.key_pair_name

  tags = { Name = "inference-vm" }
}
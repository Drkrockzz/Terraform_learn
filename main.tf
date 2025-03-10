resource "aws_vpc" "vpc_east1" {
  cidr_block = "192.130.0.0/20"

  tags = { 
    Name = "tarraform"
  }
}

resource "aws_subnet" "sub-1a" {
  vpc_id = aws_vpc.vpc_east1.id
  cidr_block = "192.130.4.0/22"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "sub-1b" {
  vpc_id = aws_vpc.vpc_east1.id
  cidr_block = "192.130.8.0/22"
  availability_zone = "us-east-1b"
}

resource "aws_subnet" "sub-1c" {
  vpc_id = aws_vpc.vpc_east1.id
  cidr_block = "192.130.12.0/22"
  availability_zone = "us-east-1c"
}

resource "aws_route_table" "sub_public" {
  vpc_id = aws_vpc.vpc_east1.id

  route {
    cidr_block = "10.1.0.0/16"
    gateway_id = "local"
  }

  route = {
    cidr_block = "0.0.0.0/0"
    gateway_id = "aws_ig"
  }
}

resource "aws_route_table_association" "_1a" {
    subnet_id = aws_subnet.sub-1a.id
    route_table_id = aws_route_table.sub_public.id
}

resource "aws_route_table_association" "_1b" {
    subnet_id = aws_subnet.sub-1b.id
    route_table_id = aws_route_table.sub_public.id
}

resource "aws_route_table_association" "_1c" {
    subnet_id = aws_subnet.sub-1c
    route_table_id = aws_route_table.sub_public.id
}

resource "aws_vpc_security_group_vpc_association" "ELB_SG" {
    security_group_id = "sg-0444cc5a7770c7f7d"
    vpc_id = aws_vpc.vpc_east1.id
}

resource "aws_instance" "myec2vm" {
  ami = "ami-05b10e08d247fb927" 
  instance_type = var.instance_type
  user_data = file("/root/app1-install.sh")
  key_name = var.aws_key
  subnet_id = aws_subnet.sub-1a.id
  vpc_security_group_ids = [var.ELB_SG ]
  tags = {
    "Name" = "EC2 Demo 2"
  }
}
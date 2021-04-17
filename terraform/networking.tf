resource "aws_vpc" "devops_page" {
  cidr_block           = "172.16.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "devops-page-${var.env_prefix}"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.devops_page.id

  tags = {
    Name = "devops-page"
  }
}

resource "aws_route_table" "r" {
  vpc_id = aws_vpc.devops_page.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "devops-page"
  }
}

resource "aws_route_table_association" "a1" {
  subnet_id      = aws_subnet.devops_page_a.id
  route_table_id = aws_route_table.r.id
}

resource "aws_route_table_association" "a2" {
  subnet_id      = aws_subnet.devops_page_b.id
  route_table_id = aws_route_table.r.id
}

resource "aws_route_table_association" "a3" {
  subnet_id      = aws_subnet.devops_page_c.id
  route_table_id = aws_route_table.r.id
}

resource "aws_subnet" "devops_page_a" {
  vpc_id            = aws_vpc.devops_page.id
  availability_zone = "us-east-2a"
  cidr_block        = "172.16.10.0/24"

  tags = {
    Name = "devops-page-${var.env_prefix}-a"
  }
}

resource "aws_subnet" "devops_page_b" {
  vpc_id            = aws_vpc.devops_page.id
  availability_zone = "us-east-2b"
  cidr_block        = "172.16.20.0/24"

  tags = {
    Name = "devops-page-${var.env_prefix}-b"
  }
}

resource "aws_subnet" "devops_page_c" {
  vpc_id            = aws_vpc.devops_page.id
  availability_zone = "us-east-2c"
  cidr_block        = "172.16.3.0/24"

  tags = {
    Name = "devops-page-${var.env_prefix}-c"
  }
}

//resource "aws_db_subnet_group" "devops-page" {
//  name       = "devops-page-rds-subnet-group"
//  subnet_ids = [aws_subnet.devops_page_a.id, aws_subnet.devops_page_b.id, aws_subnet.devops_page_c.id]
//
//  tags = {
//    Name = "devops-page DB subnet group"
//  }
//}


data "aws_availability_zones" "all" {}
//resource "aws_security_group" "http-web-access" {
//  vpc_id = aws_vpc.myservice_vpc.id
//  name = "myservice-http-${var.env_prefix}"
//
//  ingress {
//    from_port = 80
//    to_port = 80
//    protocol = "tcp"
//    cidr_blocks = [aws_vpc.myservice_vpc.cidr_block]
//  }
//  egress {
//    from_port = 80
//    protocol = "tcp"
//    to_port = 80
//    cidr_blocks = ["0.0.0.0/0"]
//  }
//}

resource "aws_security_group" "https-web-access" {
  vpc_id = aws_vpc.devops_page.id
  name   = "https-web-access"

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.devops_page.cidr_block]
    ipv6_cidr_blocks = [aws_vpc.devops_page.ipv6_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

//resource "aws_security_group" "ssh-access" {
//  vpc_id = aws_vpc.myservice_vpc.id
//  name = "myservice-ssh-${var.env_prefix}"
//  ingress {
//    from_port   = 22
//    to_port     = 22
//    protocol    = "tcp"
//    cidr_blocks = ["0.0.0.0/0"]
//  }
//  egress {
//    from_port   = 0
//    to_port     = 0
//    protocol    = "-1"
//    cidr_blocks = ["0.0.0.0/0"]
//  }
//}

//resource "aws_security_group" "db-access" {
//  vpc_id = aws_vpc.myservice_vpc.id
//  name = "myservice-db-${var.env_prefix}"
//  ingress {
//    from_port   = 3306
//    to_port     = 3306
//    protocol    = "tcp"
//    cidr_blocks = [aws_vpc.myservice_vpc.cidr_block]
//  }
//  egress {
//    from_port = 3306
//    to_port = 3306
//    protocol = "tcp"
//    cidr_blocks = [aws_vpc.myservice_vpc.cidr_block]
//  }
//}

//resource "aws_security_group" "elb" {
//  vpc_id = aws_vpc.myservice_vpc.id
//  name = "myservice-elb-${var.env_prefix}"
//
//  ingress {
//    from_port   = 80
//    to_port     = var.elb_port
//    protocol    = "tcp"
//    cidr_blocks = ["0.0.0.0/0"]
//  }
//  egress {
//    from_port   = 0
//    to_port     = 0
//    protocol    = "-1"
//    cidr_blocks = ["0.0.0.0/0"]
//  }
//}

resource "aws_security_group" "elb" {
  vpc_id = aws_vpc.devops_page.id
  name   = "devops-page-elb"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
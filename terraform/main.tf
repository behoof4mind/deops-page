provider "aws" {}

terraform {
  backend "s3" {}
}

resource "aws_autoscaling_group" "devops-page" {
  name                 = "devops-page-${var.env_prefix}"
  launch_configuration = aws_launch_configuration.devops-page.id
  //  availability_zones   = data.aws_availability_zones.all.names
  vpc_zone_identifier = [aws_subnet.devops_page_a.id, aws_subnet.devops_page_b.id, aws_subnet.devops_page_c.id]

  min_size = var.max_ec2_instances
  max_size = var.min_ec2_instances

  load_balancers    = [aws_elb.devops-page.name]
  health_check_type = "ELB"

  tag {
    key                 = "Name"
    value               = "terraform-asg-devops-page-${var.env_prefix}"
    propagate_at_launch = true
  }
}

resource "aws_launch_configuration" "devops-page" {
  name_prefix   = "devops-page-${var.env_prefix}"
  image_id      = "ami-01e7ca2ef94a0ae86"
  instance_type = "t2.micro"
  key_name      = "macos16"
  associate_public_ip_address = true
  //  security_groups = [aws_security_group.http-web-access.id, aws_security_group.https-web-access.id, aws_security_group.ssh-access.id,aws_security_group.db-access.id]
  security_groups = [aws_security_group.elb.id]

  user_data = <<-REALEND
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y docker.io
              usermod -aG docker ubuntu

              sudo curl -L "https://github.com/docker/compose/releases/download/1.28.6/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
              sudo chmod +x /usr/local/bin/docker-compose

              sudo usermod -aG docker $USER

              cat <<EOF >/home/ubuntu/docker-compose.yml
              devops-page:
                image: behoof4mind/devops-page:${var.app_version}
                ports:
                  - "80:${var.server_port}"
                environment:
                  - TEST_RUN=${var.is_temp_env}
              EOF

              sudo chown ubuntu:ubuntu /home/ubuntu/docker-compose.yml
              sudo /usr/local/bin/docker-compose -f /home/ubuntu/docker-compose.yml up -d
              REALEND

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_elb" "devops-page" {
  name            = "devops-page"
  security_groups = [aws_security_group.elb.id]
  subnets         = [aws_subnet.devops_page_a.id, aws_subnet.devops_page_b.id, aws_subnet.devops_page_c.id]

  health_check {
    target              = "HTTP:80/"
    interval            = 30
    timeout             = 10
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  listener {
    lb_port            = var.elb_port
    lb_protocol        = "https"
    instance_port      = 80
    instance_protocol  = "http"
    ssl_certificate_id = aws_acm_certificate.cert.id
  }
}

resource "aws_route53_zone" "main" {
  name = "dlavrushko.de"
  tags = {
    Environment = "prod"
  }
}

//resource "aws_route53_zone" "test" {
//  name = "test.dlavrushko.de"
//  tags = {
//    Environment = "test"
//  }
//}

//resource "aws_route53_zone" "test" {
//  name = "test.dlavrushko.com"
//
//  tags = {
//    Environment = "test"
//  }
//}

resource "aws_route53_record" "main" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "dlavrushko.de"
  type    = "A"

  alias {
    name                   = aws_elb.devops-page.dns_name
    zone_id                = aws_elb.devops-page.zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "ns" {
  allow_overwrite = true
  name            = "dlavrushko.de"
  ttl             = 172800
  type            = "NS"
  zone_id         = aws_route53_zone.main.zone_id

  records = [
    "ns-235.awsdns-29.com",
    "ns-1320.awsdns-37.org",
    "ns-556.awsdns-05.net",
    "ns-1556.awsdns-02.co.uk",
  ]
}

resource "aws_acm_certificate" "cert" {
  domain_name       = "dlavrushko.de"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "example" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.main.zone_id
}

//resource "aws_route53_record" "subdomain-ns" {
//  allow_overwrite = true
//  name            = "test.dlavrushko.de"
//  ttl             = 180
//  type            = "NS"
//  zone_id         = aws_route53_zone.main.zone_id
//
//  records = [
//    aws_route53_zone.test.name_servers[0],
//    aws_route53_zone.test.name_servers[1],
//    aws_route53_zone.test.name_servers[2],
//    aws_route53_zone.test.name_servers[3],
//  ]
//}

//resource "aws_route53_record" "test" {
//  zone_id = aws_route53_zone.test.zone_id
//  name    = "test.dlavrushko.de"
//  type    = "A"
//
//  alias {
//    name                   = aws_elb.devops-page-test.dns_name
//    zone_id                = aws_elb.devops-page-test.zone_id
//    evaluate_target_health = false
//  }
//}

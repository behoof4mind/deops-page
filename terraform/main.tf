provider "aws" {}

terraform {
  backend "s3" {}
  required_version = ">= 0.12.26"
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
  // public ip should be turned off after tests
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
                image: behoof4mind/devops-page:${var.app_version}-${var.env_prefix}
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
  name            = "devops-page-${var.env_prefix}"
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
    lb_port           = var.elb_port
    lb_protocol       = "http"
    instance_port     = 80
    instance_protocol = "http"
  }
}
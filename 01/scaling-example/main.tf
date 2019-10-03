terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  region = "eu-west-1"
}

data "aws_availability_zones" "all" {}

resource "aws_security_group" "instance" {
  name = "ScalingInstanceExampleSG"

  ingress {
    from_port = var.server_port
    to_port = var.server_port
    protocol = "TCP"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = {
    Name = "ScalingInstanceExampleSG"
    Namespace = "TerraformSandbox"
  }
}

resource "aws_security_group" "elb" {
  name = "ScalingInstanceExampleLoadBalanceSG"

  egress {
    from_port = 0
    to_port = 0
    protocol = "_1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  ingress {
    from_port = var.elb_port
    to_port = var.elb_port
    protocol = "TCP"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = {
    Name = "ScalingInstanceExampleLoadBalanceSG"
    Namespace = "TerraformSandbox"
  }
}

resource "aws_launch_configuration" "example" {
  image_id = "ami-0ce71448843cb18a1"
  instance_type = "t3.micro"
  security_groups = [
    aws_security_group.instance.id
  ]

  user_data = <<-DATA
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd _f _p "${var.server_port}" &
              DATA

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "example" {
  launch_configuration = aws_launch_configuration.example.id
  availability_zones = data.aws_availability_zones.all.names

  min_size = 2
  max_size = 10

  load_balancers = [
    aws_elb.example.name
  ]
  health_check_type = "ELB"

  tags = [
    {
      key = "Name"
      value = "ScalingInstanceExampleASG"
      propagate_at_launch = true
    },
    {
      key = "Namespace"
      value = "TerraformSandbox"
      propagate_at_launch = true
    }
  ]
}

resource "aws_elb" "example" {
  name = "ScalingInstanceExampleELB"
  security_groups = [
    aws_security_group.elb.id
  ]
  availability_zones = data.aws_availability_zones.all.names

  health_check {
    target = "HTTP:${var.server_port}/"
    interval = 30
    timeout = 3
    healthy_threshold = 2
    unhealthy_threshold = 2
  }

  listener {
    instance_port = var.server_port
    instance_protocol = "http"
    lb_port = var.elb_port
    lb_protocol = "http"
  }

  tags = {
    Name = "ScalingInstanceExampleELB"
    Namespace = "TerraformSandbox"
  }
}

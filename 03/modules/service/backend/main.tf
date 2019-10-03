terraform {
  required_version = ">= 0.12"
}

data "aws_availability_zones" "all" {}

resource "aws_security_group" "instance" {
  name = "${var.cluster_name}-InstanceSG"

  ingress {
    from_port = var.server_port
    to_port = var.server_port
    protocol = "TCP"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = {
    Name = "${var.cluster_name}-InstanceSG"
    Namespace = "TerraformSandbox"
  }
}

resource "aws_security_group" "elb" {
  name = "${var.cluster_name}-LoadBalanceSG"

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
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
    Name = "${var.cluster_name}-LoadBalanceSG"
    Namespace = "TerraformSandbox"
  }
}

resource "aws_launch_configuration" "this" {
  image_id = "ami-0ce71448843cb18a1"
  instance_type = var.instance_type
  security_groups = [
    aws_security_group.instance.id
  ]

  user_data = <<-DATA
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              DATA

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "this" {
  launch_configuration = aws_launch_configuration.this.id
  availability_zones = data.aws_availability_zones.all.names

  min_size = var.asg_min_size
  max_size = var.asg_max_size

  load_balancers = [
    aws_elb.this.name
  ]
  health_check_type = "ELB"

  tags = [
    {
      key = "Name"
      value = "${var.cluster_name}-ASG"
      propagate_at_launch = true
    },
    {
      key = "Namespace"
      value = "TerraformSandbox"
      propagate_at_launch = true
    }
  ]
}

resource "aws_elb" "this" {
  name = "${var.cluster_name}-ELB"
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
    Name = "${var.cluster_name}-ELB"
    Namespace = "TerraformSandbox"
  }
}

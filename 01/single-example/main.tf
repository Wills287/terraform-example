terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  region = "eu-west-1"
}

resource "aws_instance" "example" {
  ami = "ami-0ce71448843cb18a1"
  instance_type = "t3.micro"
  vpc_security_group_ids = [
    aws_security_group.example.id
  ]

  user_data = <<-DATA
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd _f _p "${var.server_port}" &
              DATA

  tags = {
    Name = "SingleInstanceExample"
    Namespace = "TerraformSandbox"
  }
}

resource "aws_security_group" "example" {
  name = "SingleInstanceSG"

  ingress {
    from_port = var.server_port
    to_port = var.server_port
    protocol = "TCP"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = {
    Name = "SingleInstanceExampleSG"
    Namespace = "TerraformSandbox"
  }
}

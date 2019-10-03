terraform {
  required_version = ">= 0.12"

  backend "s3" {
    bucket = "s3-wills-tf-state"
    key = "state-lookup-example/data-storage/mysql/terraform.tfstate"
    region = "eu-west-1"

    dynamodb_table = "ddb-wills-tf-locks"
    encrypt = true
  }
}

provider "aws" {
  region = "eu-west-1"
}

resource "aws_db_instance" "example" {
  identifier_prefix = "example"
  engine = "mysql"
  allocated_storage = 10
  instance_class = "db.t2.micro"
  name = "RemoteBackendExampleDB"
  username = "admin"
  password = var.db_password
}

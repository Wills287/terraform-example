terraform {
  required_version = ">= 0.12"

  backend "s3" {
    bucket = "s3-wills-tf-state"
    key = "global/s3/terraform.tfstate"
    region = "eu-west-1"

    dynamodb_table = "ddb-wills-tf-locks"
    encrypt = true
  }
}

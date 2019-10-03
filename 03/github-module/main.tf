terraform {
  required_version = ">= 0.12"
}

module "instance" {
  source = "github.com/Wills287/terraform-modules//aws/ec2/single-instance?ref=v0.0.1"

  name = "GithubModuleInstance"
  region = var.region
  tags = {
    Name: "GithubModuleInstance"
    Namespace: "TerraformSandbox"
  }
}

provider "aws" {
  region = var.region
}

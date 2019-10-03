terraform {
  required_version = ">= 0.12"
}

module "config" {
  source = "../../../base-config"
}

module "webserver_backend_cluster" {
  source = "../../../modules/service/backend"

  cluster_name = "StageWebserver"
  instance_type = "t3.micro"
  asg_min_size = 2
  asg_max_size = 2
}

provider "aws" {
  region = module.config.region
}

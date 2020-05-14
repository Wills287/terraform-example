module "vpc" {
  source = "git::https://github.com/Wills287/terraform-modules//aws/networking/vpc?ref=v0.0.10"

  enabled = var.enabled
  namespace = var.namespace
  environment = var.environment
  name = var.name
  service = var.service
  delimiter = var.delimiter
  attributes = var.attributes
  tags = var.tags

  cidr_block = var.cidr_block
}

module "subnets" {
  source = "git::https://github.com/Wills287/terraform-modules//aws/networking/subnet?ref=v0.0.10"

  enabled = var.enabled
  namespace = var.namespace
  environment = var.environment
  name = var.name
  service = var.service
  delimiter = var.delimiter
  attributes = var.attributes
  tags = var.tags

  availability_zones = var.availability_zones
  cidr_block = module.vpc.vpc_cidr_block
  vpc_id = module.vpc.vpc_id
}

module "cluster" {
  source = "git::https://github.com/Wills287/terraform-modules//aws/eks/cluster?ref=v0.0.10"

  enabled = var.enabled
  namespace = var.namespace
  environment = var.environment
  name = var.name
  service = var.service
  delimiter = var.delimiter
  attributes = var.attributes
  tags = var.tags

  kubernetes_version = var.kubernetes_version
  subnet_ids = module.subnets.private_subnet_ids
  vpc_id = module.vpc.vpc_id
}

module "node_group" {
  source = "git::https://github.com/Wills287/terraform-modules//aws/eks/node-group?ref=v0.0.10"

  enabled = var.enabled
  namespace = var.namespace
  environment = var.environment
  name = var.name
  service = var.service
  delimiter = var.delimiter
  attributes = var.attributes
  tags = var.tags

  cluster_name = module.cluster.eks_cluster_id
  desired_size = var.desired_size
  max_size = var.max_size
  min_size = var.min_size
  subnet_ids = module.subnets.private_subnet_ids
}

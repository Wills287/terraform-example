/* ---------------------------------------------------------------------------------------------------------------------
  ENVIRONMENT VARIABLES
--------------------------------------------------------------------------------------------------------------------- */

# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY

/* ---------------------------------------------------------------------------------------------------------------------
  METADATA VARIABLES
--------------------------------------------------------------------------------------------------------------------- */

variable "enabled" {
  description = "Set to false to prevent the module from creating any resources"
  type = bool
  default = true
}

variable "namespace" {
  description = "Namespace, which may relate to the overarching domain or specific business division"
  type = string
  default = ""
}

variable "environment" {
  description = "Describes the environment, e.g. 'PROD', 'staging', 'u', 'dev'"
  type = string
  default = ""
}

variable "name" {
  description = "Identifier for a specific application that may consist of many disparate resources"
  type = string
  default = ""
}

variable "service" {
  description = "Describes an individual microservice running as part of a larger application"
  type = string
  default = ""
}

variable "delimiter" {
  description = "Delimiter to output between 'namespace', 'environment', 'name', 'service' and 'attributes'"
  type = string
  default = "-"
}

variable "attributes" {
  description = "Any additional miscellaneous attributes to append to the identifier, e.g. 'cluster', 'worker'"
  type = list(string)
  default = []
}

variable "tags" {
  description = "Additional tags to apply, e.g. '{Owner = 'ABC', Product = 'DEF'}'"
  type = map(string)
  default = {}
}

/* ---------------------------------------------------------------------------------------------------------------------
  REQUIRED VARIABLES
--------------------------------------------------------------------------------------------------------------------- */

variable "region" {
  description = "Region to provision resources in"
  type = string
}

variable "cidr_block" {
  description = "CIDR block for the VPC"
  type = string
}

variable "availability_zones" {
  description = "List of Availability Zones to create resources in"
  type = list(string)
}

variable "kubernetes_version" {
  description = "Desired Kubernetes version, e.g. '1.15'"
  type = string
}

/* ---------------------------------------------------------------------------------------------------------------------
  OPTIONAL VARIABLES
--------------------------------------------------------------------------------------------------------------------- */

variable "oidc_provider_enabled" {
  description = "Create an IAM OIDC identity provider for the cluster, allowing association of IAM roles with service accounts"
  type = bool
  default = false
}

variable "enabled_cluster_log_types" {
  description = "A list of control plane aspects to enable logging for, available options: ['api', 'audit', 'authenticator', 'controllerManager', 'scheduler']"
  type = list(string)
  default = []
}

variable "cluster_log_retention_period" {
  description = "Number of days to retain cluster logs. Requires 'enabled_cluster_log_types' to be set"
  type = number
  default = 0
}

variable "desired_size" {
  description = "Desired cluster size"
  type = number
  default = 2
}

variable "max_size" {
  description = "Maximum cluster size"
  type = number
  default = 2
}

variable "min_size" {
  description = "Minimum cluster size"
  type = number
  default = 2
}

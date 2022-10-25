variable "account_name" {
  description = "The name of the AWS account we're using"
  type        = string
}

variable "environment" {
  description = "The environment name to be used when creating AWS resources"
  type        = string
}

variable "default_ami_version_pattern" {
  default =   "\\d.\\d.\\d-\\d+"
  description = "The default AMI version pattern to use when matching AMIs for instances"
  type        = string
}

variable "default_instance_type" {
  default     = "t3.medium"
  description = "The default instance type to use for instances"
  type        = string
}

variable "region" {
  description = "The AWS region in which resources will be created"
  type        = string
}

variable "repository_name" {
  default     = "artifactory"
  description = "The name of the repository in which we're operating"
  type        = string
}

variable "service" {
  default     = "artifactory"
  description = "The service name to be used when creating AWS resources"
  type        = string
}

variable "team" {
  default     = "platform"
  description = "The name of the team"
  type        = string
}
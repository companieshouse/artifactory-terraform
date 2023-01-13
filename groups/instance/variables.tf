variable "account_name" {
  description = "The name of the AWS account we are using"
  type        = string
}

variable "environment" {
  description = "The environment name to be used when creating AWS resources"
  type        = string
}

variable "default_ami_version_pattern" {
  description = "The default AMI version pattern to use when matching AMIs for instances"
  default =   "\\d.\\d.\\d-\\d+"
  type        = string
}

variable "default_instance_type" {
  description = "The default instance type to use for instances"
  default     = "t3.medium"
  type        = string
}

variable "region" {
  description = "The AWS region in which resources will be created"
  type        = string
}

variable "repository_name" {
  description = "The name of the repository in which we are operating"
  default     = "artifactory"
  type        = string
}

variable "service" {
  description = "The service name to be used when creating AWS resources"
  default     = "artifactory"
  type        = string
}

variable "team" {
  description = "The name of the team"
  default     = "platform"
  type        = string
}

variable "instance_count" {
  description = "Number of instances"
  type        = number
  default     = 1
}

variable "db_engine" {
  description = "Database engine"
  default     = "mysql"
  type        = string
}

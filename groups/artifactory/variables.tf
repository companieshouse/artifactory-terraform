# ------------------------------------------------------------------------------
# AWS Variables
# ------------------------------------------------------------------------------
variable "account_name" {
  description = "The name of the AWS account we're using"
  default     = "development"
  type        = string
}

variable "environment" {
  description = "The environment name to be used when creating AWS resources"
  default     = "devops1"
  type        = string
}

variable "region" {
  description = "The AWS region in which resources will be created"
  default     = "eu-west-2"
  type        = string
}

variable "repository_name" {
  description = "The name of the repository in which we're operating"
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


variable "account_name" {
  description = "The name of the AWS account we're using"
  type        = string
}

variable "environment" {
  default     = "devops1"
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

variable "db_engine" {
  default     = "mysql"
  description = "Database engine"
  type        = string
}

variable "db_engine_version" {
  default = "8.0"
}

variable "db_instance_class" {
  default = "db.t4g.small"
}

variable "db_storage_type" {
  default = "gp2"
}

variable "db_storage_gb" {
  default = 20
}

variable "rds_cloudwatch_export_logs_retention_period" {
  default     = 180
  type        = number
  description = "The set value for retention period of rds export cloudwatch logs, setting the period in days value"
}

variable "rds_cloudwatch_logs_exports" {
  default     = ["audit", "error", "general", "slowquery"]
  type        = list(any)
  description = "List of chosen log exports for MySQL RDS Cloudwatch Logs"
}

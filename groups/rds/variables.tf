variable "account_name" {
  description = "The name of the AWS account we're using"
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

variable "db_engine" {
  description = "Database engine"
  default     = "mysql"
  type        = string
}

variable "db_engine_version" {
  description = "Database engine version"
  default     = "8.0"
  type        = string
}

variable "db_instance_class" {
  description = "Database instance class"
  default     = "db.t4g.small"
  type        = string
}

variable "db_storage_type" {
  description = "Database storage type"
  default     = "gp2"
  type        = string
}

variable "db_storage_gb" {
  description = "Database storage gigabytes"
  default     = 20
  type        = number
}

variable "rds_cloudwatch_export_logs_retention_period" {
  description = "The set value for retention period of rds export cloudwatch logs, setting the period in days value"
  default     = 180
  type        = number
}

variable "rds_cloudwatch_logs_exports" {
  description = "List of chosen log exports for MySQL RDS Cloudwatch Logs"
  default     = ["audit", "error", "general", "slowquery"]
  type        = list(any)
}

variable "db_deletion_protection" {
  description = "Database deletion protection"
  default     = true
  type        = bool
}

variable "db_backup_retention_period" {
  description = "Database backup retention period"
  default     = 7
  type        = number
}

variable "db_backup_window" {
  description = "Database backup window"
  default     = "03:00-06:00"
  type        = string
}

variable "db_maintenance_window" {
  description = "Database maintenance window"
  default     = "Sat:00:00-Sat:03:00"
  type        = string
}

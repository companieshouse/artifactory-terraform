variable "account_name" {
  description = "The name of the AWS account we're using"
  type        = string
}

variable "environment" {
  description = "The environment name to be used when creating AWS resources"
  type        = string
}

variable "region" {
  default     = "eu-west-2"
  description = "The AWS region in which resources will be created"
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

#-------------------------------------------------------------------------------
# RDS Variables
#-------------------------------------------------------------------------------
variable "db_backup_retention_period" {
  default     = 7
  description = "Database backup retention period"
  type        = number
}

variable "db_backup_window" {
  default     = "03:00-06:00"
  description = "Database backup window"
  type        = string
}

variable "db_deletion_protection" {
  default     = true
  description = "Database deletion protection"
  type        = bool
}

variable "db_engine" {
  default     = "postgres"
  description = "Database engine"
  type        = string
}

variable "db_engine_major_version" {
  default     = "13"
  description = "Database engine major version"
  type        = string
}

variable "db_instance_class" {
  default     = "db.t3.small"
  description = "Database instance class"
  type        = string
}

variable "db_instance_multi_az" {
  default     = false
  description = "Defines whether the RDS should be deployed as Multi-AZ (true) or not (false)"
  type        = bool
}

variable "db_maintenance_window" {
  default     = "Sat:00:00-Sat:03:00"
  description = "Database maintenance window"
  type        = string
}

variable "db_port" {
  default     = 5432
  description = "The port that the database can be reached on"
  type        = number

}

variable "db_storage_gb" {
  default     = 20
  description = "Database storage gigabytes"
  type        = number
}

variable "dns_zone_is_private" {
  default     = true
  description = "Defines whether the configured DNS zone is a private zone (true) or public (false)"
  type        = bool
}

variable "rds_cloudwatch_logs_exports" {
  default     = ["postgresql", "upgrade"]
  description = "List of chosen log exports for database RDS Cloudwatch Logs"
  type        = list(any)
}

variable "rds_kms_key_alias" {
  description = "Alias for the KMS key used to encrypt RDS storage, including the alias/ prefix"
  type        = string
}

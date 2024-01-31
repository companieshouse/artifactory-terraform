variable "account_name" {
  description = "The name of the AWS account we are using"
  type        = string
}

variable "environment" {
  description = "The environment name to be used when creating AWS resources"
  type        = string
}

variable "default_instance_type" {
  description = "The default instance type to use for instances"
  default     = "t3.large"
  type        = string
}

variable "default_ami_version_pattern" {
  description = "The default AMI version pattern to use when matching AMIs for instances"
  default     = "\\d.\\d.\\d"
  type        = string
}

variable "region" {
  description = "The AWS region in which resources will be created"
  default     = "eu-west-2"
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

variable "db_engine" {
  description = "Database engine"
  default     = "postgres"
  type        = string
}

variable "ebs_root_delete_on_termination" {
  description = "Whether the volume should be destroyed on instance termination. Defaulted to false"
  default     = "false"
  type        = string
}

variable "ebs_root_encrypted" {
  description = "Enables EBS encryption on the volume."
  default     = "false"
  type        = string
}

variable "ebs_root_iops" {
  description = "Amount of provisioned IOPS."
  default     = 3000
  type        = number
}

variable "ebs_root_throughput" {
  description = "Throughput to provision for a volume in mebibytes per second (MiB/s)"
  default     = 125
  type        = number
}

variable "ebs_root_volume_size" {
  description = "Size of the volume in gibibytes (GiB)"
  default     = 20
  type        = number
}

variable "ebs_root_volume_type" {
  description = "Type of volume"
  default     = "gp3"
  type        = string
}

variable "efs_permit_client_root_access" {
  description = "Enable clients to perform root operations on the filesystem"
  default     = "true"
  type        = string
}

variable "efs_module_test_service" {
  description = "The service name to be used when creating AWS resources"
  default     = "artifactory-efs-module-test"
  type        = string
}

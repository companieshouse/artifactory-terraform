variable "account_name" {
  description = "The name of the AWS account we are using"
  type        = string
}

variable "environment" {
  description = "The environment name to be used when creating AWS resources"
  type        = string
}

variable "region" {
  description = "The AWS region in which resources will be created"
  default     = "eu-west-2"
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

# ------------------
variable "instance_type" {
  description = "The instance type to use for instances"
  default     = "t3.large"
  type        = string
}

variable "ami_version_pattern" {
  description = "The AMI version pattern to use when matching AMIs for instances"
  default     = "\\d.\\d.\\d"
  type        = string
}


variable "repository_name" {
  description = "The name of the repository in which we are operating"
  default     = "artifactory"
  type        = string
}


variable "db_engine" {
  description = "Database engine"
  default     = "postgres"
  type        = string
}

variable "dns_zone_is_private" {
  default     = true
  description = "Defines whether the configured DNS zone is a private zone (true) or public (false)"
  type        = bool
}

variable "ebs_root_delete_on_termination" {
  description = "Whether the volume should be destroyed on instance termination. Defaulted to false"
  default     = "false"
  type        = string
}

variable "ebs_root_encrypted" {
  description = "Enables EBS encryption on the volume."
  default     = "true"
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
  default     = true
  type        = bool
}

variable "kms_key_usage" {
  description = "Specifies the intended use of the key"
  default     = "ENCRYPT_DECRYPT"
  type        = string
}

variable "kms_customer_master_key_spec" {
  description = "Specifies whether the key contains a symmetric key or an asymmetric key pair and the encryption algorithms or signing algorithms that the key supports"
  default     = "SYMMETRIC_DEFAULT"
  type        = string
}

variable "kms_is_enabled" {
  description = "Specifies whether the key is enabled"
  default     = "true"
  type        = string
}

variable "kms_enable_key_rotation" {
  description = "Specifies whether key rotation is enabled"
  default     = "false"
  type        = string
}

variable "efs_artifacts_access_point_name" {
  description = "The name to create and retrieve the artifacts EFS access point"
  default     = "artifacts"
  type        = string
}

variable "block_device_name" {
  description = "The name of the Root Block device"
  default     = "/dev/xvda"
  type        = string
}

variable "alb_deregistration_delay" {
  default     = 60
  description = "The time, in seconds, that connections will be drained before the target is removed from the ALB target group"
  type        = number
}

variable "asg_health_check_grace_period" {
  description = "Time (in seconds) after instance comes into service before checking health. Default 300"
  default     = 150
  type        = number
}

variable "asg_desired_capacity" {
  description = "The number of Amazon EC2 instances that should be running in the group."
  default     = 1
  type        = number
}

variable "asg_min_size" {
  description = "The minimum size of the auto scale group"
  default     = 1
  type        = number
}

variable "asg_max_size" {
  description = "The maximum size of the auto scale group"
  default     = 1
  type        = number
}

variable "asg_health_check_type" {
  description = "EC2 or ELB. Controls how health checking is carried out"
  default     = "EC2"
  type        = string
}

variable "asg_termination_policies" {
  description = "A list of policies to decide how the instances in the auto scale group should be terminated"
  default     = "OldestInstance"
  type        = string
}

variable "asg_default_cooldown" {
  description = "The amount of time, in seconds, after a scaling activity completes before another scaling activity can start"
  default     = 10
  type        = number
}

variable "asg_launch_template_version" {
  description = "Template version. Can be version number, $Latest, or $Default"
  default     = "$Latest"
  type        = string
}

variable "aws_command" {
  description = "The base aws cli get-parameter command"
  default     = "aws ssm get-parameter --with-decryption --output text"
  type        = string
}

variable "user_data_merge_strategy" {
  default     = "list(append)+dict(recurse_array)+str()"
  description = "Merge strategy to apply to user-data sections for cloud-init"
}

variable "asg_time_zone" {
  description = "Specifies the time zone for a cron expression"
  default     = "Europe/London"
  type        = string
}

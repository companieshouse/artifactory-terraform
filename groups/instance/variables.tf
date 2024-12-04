variable "account_name" {
  description = "The name of the AWS account we are using"
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

variable "instance_type" {
  default     = "t3.large"
  description = "The instance type to use for instances"
  type        = string
}

#-------------------------------------------------------------------------------
# Infrastructure Variables
#-------------------------------------------------------------------------------
variable "ami_version_pattern" {
  default     = "\\d.\\d.\\d"
  description = "The AMI version pattern to use when matching AMIs for instances"
  type        = string
}

variable "repository_name" {
  default     = "artifactory"
  description = "The name of the repository in which we are operating"
  type        = string
}


variable "db_engine" {
  default     = "postgres"
  description = "Database engine"
  type        = string
}

variable "dns_zone_is_private" {
  default     = true
  description = "Defines whether the configured DNS zone is a private zone (true) or public (false)"
  type        = bool
}

variable "ebs_root_delete_on_termination" {
  default     = "false"
  description = "Whether the volume should be destroyed on instance termination. Defaulted to false"
  type        = string
}

variable "ebs_root_iops" {
  default     = 3000
  description = "EBS volume IOPS; 3000 is the gp3 default"
  type        = number
}

variable "ebs_root_throughput" {
  default     = 125
  description = "EBS volume throughput in MiB/s; 125 is the gp3 default"
  type        = number
}

variable "ebs_root_volume_size" {
  default     = 20
  description = "Size of the volume in gibibytes (GiB)"
  type        = number
}

variable "ebs_root_volume_type" {
  default     = "gp3"
  description = "EBS volume type to provision"
  type        = string
}

variable "efs_artifacts_access_point_name" {
  default     = "artifacts"
  description = "The name to create and retrieve the artifacts EFS access point"
  type        = string
}

variable "efs_permit_client_root_access" {
  default     = true
  description = "Enable clients to perform root operations on the filesystem"
  type        = bool
}

variable "kms_key_usage" {
  default     = "ENCRYPT_DECRYPT"
  description = "Specifies the intended use of the key"
  type        = string
}

variable "kms_customer_master_key_spec" {
  default     = "SYMMETRIC_DEFAULT"
  description = "Specifies whether the key contains a symmetric key or an asymmetric key pair and the encryption algorithms or signing algorithms that the key supports"
  type        = string
}

variable "kms_is_enabled" {
  default     = "true"
  description = "Specifies whether the key is enabled"
  type        = string
}

variable "kms_enable_key_rotation" {
  default     = "false"
  description = "Specifies whether key rotation is enabled"
  type        = string
}

variable "alb_deregistration_delay" {
  default     = 60
  description = "The time, in seconds, that connections will be drained before the target is removed from the ALB target group"
  type        = number
}

variable "asg_default_cooldown" {
  default     = 10
  description = "The amount of time, in seconds, after a scaling activity completes before another scaling activity can start"
  type        = number
}

variable "asg_desired_capacity" {
  default     = 1
  description = "The number of Amazon EC2 instances that should be running in the group."
  type        = number
}

variable "asg_health_check_grace_period" {
  default     = 150
  description = "Time (in seconds) after instance comes into service before checking health. Default 150"
  type        = number
}

variable "asg_health_check_type" {
  default     = "EC2"
  description = "EC2 or ELB. Controls how health checking is carried out"
  type        = string
}

variable "asg_min_size" {
  default     = 1
  description = "The minimum size of the auto scale group"
  type        = number
}

variable "asg_max_size" {
  default     = 1
  description = "The maximum size of the auto scale group"
  type        = number
}

variable "asg_termination_policies" {
  default     = "OldestInstance"
  description = "A list of policies to decide how the instances in the auto scale group should be terminated"
  type        = string
}

variable "asg_launch_template_version" {
  default     = "$Latest"
  description = "Template version. Can be version number, $Latest, or $Default"
  type        = string
}

variable "asg_time_zone" {
  default     = "Europe/London"
  description = "Specifies the time zone for a cron expression"
  type        = string
}

variable "cloudwatch_log_group_retention_in_days" {
  default     = 14
  description = "The number of days to retain cloudwatch logs"
  type        = number
}

#-------------------------------------------------------------------------------
# Application & Bootstrap variables
#-------------------------------------------------------------------------------
variable "artifactory_base_path" {
  default     = "/opt/jfrog/artifactory"
  description = "The base install path for Artifactory"
  type        = string
}

variable "artifactory_config_server_name" {
  description = "The full display name for the Artifactory server instance"
  type        = string
}

variable "artifactory_group" {
  default     = "artifactory"
  description = "The system group that the Artifactory service user is a member of"
  type        = string
}

variable "artifactory_user" {
  default     = "artifactory"
  description = "The system user that the Artifactory service runs as"
  type        = string
}

variable "aws_command" {
  default     = "aws ssm get-parameter --with-decryption --output text"
  description = "The base aws cli get-parameter command used during instance bootstrap"
  type        = string
}

variable "cloudwatch_logs_collected" {
  default     = []
  description = "A list of objects that contain key=value pairs, used to generate cloudwatch agent config for collecting application logs"
  type = list(object(
    {
      name             = string
      timestamp_format = optional(string, "%Y-%m-%dT%H:%M:%S.%f")
    }
  ))
}

variable "lvm_block_devices" {
  description = "A list of objects representing LVM block devices; each LVM volume group is assumed to contain a single physical volume and each logical volume is assumed to belong to a single volume group; the filesystem for each logical volume will be expanded to use all available space within the volume group using the filesystem resize command specified; block device configuration applies only on resource creation"
  type = list(object({
    aws_volume_size_gb : string,
    delete_on_termination : bool,
    filesystem_resize_command : string,
    lvm_logical_volume_device_node : string,
    lvm_physical_volume_device_node : string,
  }))
}

variable "user_data_merge_strategy" {
  default     = "list(append)+dict(recurse_array)+str()"
  description = "Merge strategy to apply to user-data sections for cloud-init"
}

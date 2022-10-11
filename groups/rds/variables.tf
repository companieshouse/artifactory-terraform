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

variable "instance_specifications" {
  description = "A map of specifications for the instances"
  type = map(map(map(string)))
}

variable "lvm_block_definitions" {
  default = [
    {
      aws_volume_size_gb: "50",
      filesystem_resize_tool: "xfs_growfs",
      lvm_logical_volume_device_node: "/dev/kafka/data",
      lvm_physical_volume_device_node: "/dev/xvdb"
    }
  ]
  description = "Kafka LVM block definitions"
  type = list(object({
    aws_volume_size_gb: string,
    filesystem_resize_tool: string,
    lvm_logical_volume_device_node: string,
    lvm_physical_volume_device_node: string,
  }))
}

variable "region" {
  description = "The AWS region in which resources will be created"
  type        = string
}

variable "repository_name" {
  default     = "artifactory-terraform"
  description = "The name of the repository in which we're operating"
  type        = string
}

variable "service" {
  default     = "artifactory"
  description = "The service name to be used when creating AWS resources"
  type        = string
}

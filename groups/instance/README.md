# artifactory-terraform/instance

Terraform scripts to provision EC2 instance and supporting resources for Artifactory

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0, < 2.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0, < 6.0 |
| <a name="requirement_cloudinit"></a> [cloudinit](#requirement\_cloudinit) | >= 2.3.0, < 3.0.0 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | >= 4.0, < 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0, < 6.0 |
| <a name="provider_cloudinit"></a> [cloudinit](#provider\_cloudinit) | >= 2.3.0, < 3.0.0 |
| <a name="provider_vault"></a> [vault](#provider\_vault) | >= 4.0, < 5.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_efs_file_system"></a> [efs\_file\_system](#module\_efs\_file\_system) | git@github.com:companieshouse/terraform-modules//aws/efs | 1.0.249 |

## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate.certificate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate_validation.certificate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation) | resource |
| [aws_autoscaling_attachment.artifactory_asg_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_attachment) | resource |
| [aws_autoscaling_group.artifactory_asg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_iam_instance_profile.artifactory](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.kms_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.ssm_parameters](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.artifactory](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.ssm_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.efs_service_core](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.kms_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ssm_parameters](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ssm_service_core](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_key_pair.artifactory](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_kms_alias.artifactory](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_grant.artifactory_grant](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_grant) | resource |
| [aws_kms_key.artifactory](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_launch_template.artifactory_launch_template](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_lb.artifactory](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.front_end_8082](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_route53_record.certificate_validation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_security_group.alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_ssm_parameter.artifactory](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_vpc_security_group_egress_rule.alb_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_egress_rule.ec2_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.alb_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.http_ingress_cidrs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.http_ingress_prefixlist](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.https_ingress_cidrs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.https_ingress_prefixlist](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_acm_certificate.certificate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/acm_certificate) | data source |
| [aws_ami.artifactory_ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_ec2_managed_prefix_list.administration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ec2_managed_prefix_list) | data source |
| [aws_ec2_managed_prefix_list.concourse](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ec2_managed_prefix_list) | data source |
| [aws_iam_policy.efs_service_core](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy.ssm_service_core](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.kms_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.kms_key_asg_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ssm_parameters](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ssm_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_role.asg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_role) | data source |
| [aws_route53_zone.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [aws_subnet.automation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_subnet.placement](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_subnets.automation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_subnets.placement](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.automation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [aws_vpc.placement](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [cloudinit_config.artifactory](https://registry.terraform.io/providers/hashicorp/cloudinit/latest/docs/data-sources/config) | data source |
| [vault_generic_secret.secrets](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.security_efs_kms_keys_data](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.security_kms_keys](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.security_s3_buckets](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_name"></a> [account\_name](#input\_account\_name) | The name of the AWS account we are using | `string` | n/a | yes |
| <a name="input_alb_deregistration_delay"></a> [alb\_deregistration\_delay](#input\_alb\_deregistration\_delay) | The time, in seconds, that connections will be drained before the target is removed from the ALB target group | `number` | `60` | no |
| <a name="input_asg_default_cooldown"></a> [asg\_default\_cooldown](#input\_asg\_default\_cooldown) | The amount of time, in seconds, after a scaling activity completes before another scaling activity can start | `number` | `10` | no |
| <a name="input_asg_desired_capacity"></a> [asg\_desired\_capacity](#input\_asg\_desired\_capacity) | The number of Amazon EC2 instances that should be running in the group. | `number` | `1` | no |
| <a name="input_asg_health_check_grace_period"></a> [asg\_health\_check\_grace\_period](#input\_asg\_health\_check\_grace\_period) | Time (in seconds) after instance comes into service before checking health. Default 300 | `number` | `150` | no |
| <a name="input_asg_health_check_type"></a> [asg\_health\_check\_type](#input\_asg\_health\_check\_type) | EC2 or ELB. Controls how health checking is carried out | `string` | `"EC2"` | no |
| <a name="input_asg_launch_template_version"></a> [asg\_launch\_template\_version](#input\_asg\_launch\_template\_version) | Template version. Can be version number, $Latest, or $Default | `string` | `"$Latest"` | no |
| <a name="input_asg_max_size"></a> [asg\_max\_size](#input\_asg\_max\_size) | The maximum size of the auto scale group | `number` | `1` | no |
| <a name="input_asg_min_size"></a> [asg\_min\_size](#input\_asg\_min\_size) | The minimum size of the auto scale group | `number` | `1` | no |
| <a name="input_asg_termination_policies"></a> [asg\_termination\_policies](#input\_asg\_termination\_policies) | A list of policies to decide how the instances in the auto scale group should be terminated | `string` | `"OldestInstance"` | no |
| <a name="input_asg_time_zone"></a> [asg\_time\_zone](#input\_asg\_time\_zone) | Specifies the time zone for a cron expression | `string` | `"Europe/London"` | no |
| <a name="input_aws_command"></a> [aws\_command](#input\_aws\_command) | The base aws cli get-parameter command | `string` | `"aws ssm get-parameter --with-decryption --output text"` | no |
| <a name="input_block_device_name"></a> [block\_device\_name](#input\_block\_device\_name) | The name of the Root Block device | `string` | `"/dev/xvda"` | no |
| <a name="input_db_engine"></a> [db\_engine](#input\_db\_engine) | Database engine | `string` | `"postgres"` | no |
| <a name="input_default_ami_version_pattern"></a> [default\_ami\_version\_pattern](#input\_default\_ami\_version\_pattern) | The default AMI version pattern to use when matching AMIs for instances | `string` | `"\\d.\\d.\\d"` | no |
| <a name="input_default_instance_type"></a> [default\_instance\_type](#input\_default\_instance\_type) | The default instance type to use for instances | `string` | `"t3.large"` | no |
| <a name="input_dns_zone_is_private"></a> [dns\_zone\_is\_private](#input\_dns\_zone\_is\_private) | Defines whether the configured DNS zone is a private zone (true) or public (false) | `bool` | `true` | no |
| <a name="input_ebs_root_delete_on_termination"></a> [ebs\_root\_delete\_on\_termination](#input\_ebs\_root\_delete\_on\_termination) | Whether the volume should be destroyed on instance termination. Defaulted to false | `string` | `"false"` | no |
| <a name="input_ebs_root_encrypted"></a> [ebs\_root\_encrypted](#input\_ebs\_root\_encrypted) | Enables EBS encryption on the volume. | `string` | `"true"` | no |
| <a name="input_ebs_root_iops"></a> [ebs\_root\_iops](#input\_ebs\_root\_iops) | Amount of provisioned IOPS. | `number` | `3000` | no |
| <a name="input_ebs_root_throughput"></a> [ebs\_root\_throughput](#input\_ebs\_root\_throughput) | Throughput to provision for a volume in mebibytes per second (MiB/s) | `number` | `125` | no |
| <a name="input_ebs_root_volume_size"></a> [ebs\_root\_volume\_size](#input\_ebs\_root\_volume\_size) | Size of the volume in gibibytes (GiB) | `number` | `20` | no |
| <a name="input_ebs_root_volume_type"></a> [ebs\_root\_volume\_type](#input\_ebs\_root\_volume\_type) | Type of volume | `string` | `"gp3"` | no |
| <a name="input_efs_artifacts_access_point_name"></a> [efs\_artifacts\_access\_point\_name](#input\_efs\_artifacts\_access\_point\_name) | The name to create and retrieve the artifacts EFS access point | `string` | `"artifacts"` | no |
| <a name="input_efs_permit_client_root_access"></a> [efs\_permit\_client\_root\_access](#input\_efs\_permit\_client\_root\_access) | Enable clients to perform root operations on the filesystem | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name to be used when creating AWS resources | `string` | n/a | yes |
| <a name="input_hashicorp_vault_password"></a> [hashicorp\_vault\_password](#input\_hashicorp\_vault\_password) | The password used when retrieving configuration from Hashicorp Vault | `string` | n/a | yes |
| <a name="input_hashicorp_vault_username"></a> [hashicorp\_vault\_username](#input\_hashicorp\_vault\_username) | The username used when retrieving configuration from Hashicorp Vault | `string` | n/a | yes |
| <a name="input_kms_customer_master_key_spec"></a> [kms\_customer\_master\_key\_spec](#input\_kms\_customer\_master\_key\_spec) | Specifies whether the key contains a symmetric key or an asymmetric key pair and the encryption algorithms or signing algorithms that the key supports | `string` | `"SYMMETRIC_DEFAULT"` | no |
| <a name="input_kms_enable_key_rotation"></a> [kms\_enable\_key\_rotation](#input\_kms\_enable\_key\_rotation) | Specifies whether key rotation is enabled | `string` | `"false"` | no |
| <a name="input_kms_is_enabled"></a> [kms\_is\_enabled](#input\_kms\_is\_enabled) | Specifies whether the key is enabled | `string` | `"true"` | no |
| <a name="input_kms_key_usage"></a> [kms\_key\_usage](#input\_kms\_key\_usage) | Specifies the intended use of the key | `string` | `"ENCRYPT_DECRYPT"` | no |
| <a name="input_region"></a> [region](#input\_region) | The AWS region in which resources will be created | `string` | `"eu-west-2"` | no |
| <a name="input_repository_name"></a> [repository\_name](#input\_repository\_name) | The name of the repository in which we are operating | `string` | `"artifactory"` | no |
| <a name="input_service"></a> [service](#input\_service) | The service name to be used when creating AWS resources | `string` | `"artifactory"` | no |
| <a name="input_team"></a> [team](#input\_team) | The name of the team | `string` | `"platform"` | no |
| <a name="input_user_data_merge_strategy"></a> [user\_data\_merge\_strategy](#input\_user\_data\_merge\_strategy) | Merge strategy to apply to user-data sections for cloud-init | `string` | `"list(append)+dict(recurse_array)+str()"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dns_hostname"></a> [dns\_hostname](#output\_dns\_hostname) | n/a |
<!-- END_TF_DOCS -->

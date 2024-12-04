# artifactory-terraform/rds

Terraform scripts to provision an RDS instance for Artifactory

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0, < 2.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0, < 6.0 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | >= 4.0, < 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0, < 6.0 |
| <a name="provider_vault"></a> [vault](#provider\_vault) | >= 4.0, < 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_db_instance.db](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_db_option_group.db_option_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_option_group) | resource |
| [aws_db_parameter_group.db_parameter_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_parameter_group) | resource |
| [aws_db_subnet_group.rds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_route53_record.db](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_security_group.rds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_vpc_security_group_egress_rule.artifactory](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.artifactory](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_kms_alias.rds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_alias) | data source |
| [aws_route53_zone.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [aws_subnet.placement](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_subnets.placement](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.placement](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [vault_generic_secret.account_ids](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.secrets](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_name"></a> [account\_name](#input\_account\_name) | The name of the AWS account we're using | `string` | n/a | yes |
| <a name="input_db_backup_retention_period"></a> [db\_backup\_retention\_period](#input\_db\_backup\_retention\_period) | Database backup retention period | `number` | `7` | no |
| <a name="input_db_backup_window"></a> [db\_backup\_window](#input\_db\_backup\_window) | Database backup window | `string` | `"03:00-06:00"` | no |
| <a name="input_db_deletion_protection"></a> [db\_deletion\_protection](#input\_db\_deletion\_protection) | Database deletion protection | `bool` | `true` | no |
| <a name="input_db_engine"></a> [db\_engine](#input\_db\_engine) | Database engine | `string` | `"postgres"` | no |
| <a name="input_db_engine_major_version"></a> [db\_engine\_major\_version](#input\_db\_engine\_major\_version) | Database engine major version | `string` | `"13"` | no |
| <a name="input_db_instance_class"></a> [db\_instance\_class](#input\_db\_instance\_class) | Database instance class | `string` | `"db.t3.small"` | no |
| <a name="input_db_instance_multi_az"></a> [db\_instance\_multi\_az](#input\_db\_instance\_multi\_az) | Defines whether the RDS should be deployed as Multi-AZ (true) or not (false) | `bool` | `false` | no |
| <a name="input_db_maintenance_window"></a> [db\_maintenance\_window](#input\_db\_maintenance\_window) | Database maintenance window | `string` | `"Sat:00:00-Sat:03:00"` | no |
| <a name="input_db_port"></a> [db\_port](#input\_db\_port) | The port that the database can be reached on | `number` | `5432` | no |
| <a name="input_db_storage_gb"></a> [db\_storage\_gb](#input\_db\_storage\_gb) | Database storage gigabytes | `number` | `20` | no |
| <a name="input_dns_zone_is_private"></a> [dns\_zone\_is\_private](#input\_dns\_zone\_is\_private) | Defines whether the configured DNS zone is a private zone (true) or public (false) | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name to be used when creating AWS resources | `string` | n/a | yes |
| <a name="input_hashicorp_vault_password"></a> [hashicorp\_vault\_password](#input\_hashicorp\_vault\_password) | The password used when retrieving configuration from Hashicorp Vault | `string` | n/a | yes |
| <a name="input_hashicorp_vault_username"></a> [hashicorp\_vault\_username](#input\_hashicorp\_vault\_username) | The username used when retrieving configuration from Hashicorp Vault | `string` | n/a | yes |
| <a name="input_rds_cloudwatch_logs_exports"></a> [rds\_cloudwatch\_logs\_exports](#input\_rds\_cloudwatch\_logs\_exports) | List of chosen log exports for database RDS Cloudwatch Logs | `list(any)` | <pre>[<br>  "postgresql",<br>  "upgrade"<br>]</pre> | no |
| <a name="input_rds_kms_key_alias"></a> [rds\_kms\_key\_alias](#input\_rds\_kms\_key\_alias) | Alias for the KMS key used to encrypt RDS storage, including the alias/ prefix | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The AWS region in which resources will be created | `string` | `"eu-west-2"` | no |
| <a name="input_service"></a> [service](#input\_service) | The service name to be used when creating AWS resources | `string` | `"artifactory"` | no |
| <a name="input_team"></a> [team](#input\_team) | The name of the team | `string` | `"platform"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_rds_route53_name"></a> [rds\_route53\_name](#output\_rds\_route53\_name) | Returns the Route53 name, or FQDN, for the RDS instance |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | Returns the id of the RDS security group |
| <a name="output_subnet_ids"></a> [subnet\_ids](#output\_subnet\_ids) | Returns a list of the subnet ids used during deployment |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | Returns the id of the VPC used during deployment |
<!-- END_TF_DOCS -->

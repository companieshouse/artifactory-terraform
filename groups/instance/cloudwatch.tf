resource "aws_cloudwatch_log_group" "artifactory" {
  name              = local.resource_prefix
  retention_in_days = var.cloudwatch_log_group_retention_in_days
  kms_key_id        = aws_kms_key.artifactory.key_id

  tags = {
    Name = "${local.resource_prefix}"
  }
}

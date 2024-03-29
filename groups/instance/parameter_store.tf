resource "aws_ssm_parameter" "artifactory" {
  for_each = local.parameter_store_secrets

  name   = "${local.param_base_path}/${each.key}"
  type   = "SecureString"
  value  = each.value
  key_id = aws_kms_alias.artifactory.arn

  tags = {
    Environment = var.environment
    Service     = var.service
    Team        = var.team
  }
}

resource "aws_kms_key" "artifactory_kms_key" {
  description              = "Artifactory Service Specific KMS Encryption Key"
  key_usage                = var.kms_key_usage
  customer_master_key_spec = var.kms_customer_master_key_spec
  is_enabled               = var.kms_is_enabled
  enable_key_rotation      = var.kms_enable_key_rotation

  tags = {
    Account     = var.account_name
    Service     = var.service
    Environment = var.environment
    Region      = var.region
    Terraform   = "true"
  }
}

resource "aws_kms_alias" "artifactory" {
  name          = "alias/${var.service}-${var.environment}-kms"
  target_key_id = aws_kms_key.artifactory_kms_key.key_id
}

resource "aws_kms_grant" "artifactory_grant" {
  name              = "${var.environment}-${var.service}-kms-grant"
  key_id            = aws_kms_key.artifactory_kms_key.key_id
  grantee_principal = "arn:aws:iam::${local.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
  operations = [
    "Decrypt",
    "ReEncryptFrom",
    "GenerateDataKey",
    "GenerateDataKeyWithoutPlaintext",
    "DescribeKey",
    "CreateGrant"
  ]
}

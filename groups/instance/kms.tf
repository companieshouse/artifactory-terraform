# ------------------------------------------------------------------------------
# KMS Key
# ------------------------------------------------------------------------------
resource "aws_kms_key" "artifactory_kms_key" {
  description         = "kms key used to manage Artifactory parameters"
  enable_key_rotation = false
}

# ------------------------------------------------------------------------------
# KMS Alias
# ------------------------------------------------------------------------------
resource "aws_kms_alias" "artifactory_kms_alias" {
  name          = "alias/artifactory-${var.environment}-kms"
  target_key_id = aws_kms_key.artifactory_kms_key.key_id
}

# ------------------------------------------------------------------------------
# KMS IAM Policy Document
# ------------------------------------------------------------------------------
data "aws_iam_policy_document" "artifactory_kms_policy_document" {
  statement {
    sid = "AllowUseOfTheKey"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = [aws_kms_key.artifactory_kms_key.arn]
  }
}

# ------------------------------------------------------------------------------
# KMS IAM User Policy
# ------------------------------------------------------------------------------
resource "aws_iam_user_policy" "artifactory_kms_policy" {
  name   = "artifactory-${var.environment}-kms-policy"
  user   = "concourse-server-${var.environment}"
  policy = data.aws_iam_policy_document.artifactory_kms_policy_document.json
}
resource "aws_kms_key" "artifactory_kms_key" {
  description              = "Artifactory Service Specific KMS Encryption Key"
  key_usage                = var.kms_key_usage
  customer_master_key_spec = var.kms_customer_master_key_spec
  is_enabled               = var.kms_is_enabled
  enable_key_rotation      = var.kms_enable_key_rotation
  policy                   = data.aws_iam_policy_document.kms_key_asg_access.json

  tags = {
    Account     = var.account_name
    Service     = var.service
    Environment = var.environment
    Region      = var.region
    Terraform   = "true"
  }
}

resource "aws_kms_alias" "artifactory" {
  name          = "alias/${local.base_path}-kms"
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

data "aws_iam_policy_document" "kms_key_asg_access" {
  statement {
    sid = "DefaultIAMUserPermissions"

    actions = [
      "kms:*"
    ]

    resources = ["*"]

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      ]
    }
  }

  statement {
    sid    = "Allow service-linked role use of the customer managed key"
    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = [
        data.aws_iam_role.asg.arn
      ]
    }

    resources = ["*"]

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*"
    ]
  }

  statement {
    sid    = "Allow attachment of persistent resources"
    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = [
        data.aws_iam_role.asg.arn
      ]
    }

    resources = ["*"]

    actions = [
      "kms:CreateGrant"
    ]

    condition {
      test     = "Bool"
      variable = "kms:GrantIsForAWSResource"
      values   = ["true"]
    }
  }
}

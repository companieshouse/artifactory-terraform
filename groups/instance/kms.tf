resource "aws_kms_key" "artifactory" {
  description              = "Artifactory Service Specific KMS Encryption Key"
  key_usage                = var.kms_key_usage
  customer_master_key_spec = var.kms_customer_master_key_spec
  is_enabled               = var.kms_is_enabled
  enable_key_rotation      = var.kms_enable_key_rotation
  policy                   = data.aws_iam_policy_document.kms_key_asg_access.json

  tags = {
    Service     = var.service
    Environment = var.environment
    Terraform   = "true"
  }
}

resource "aws_kms_alias" "artifactory" {
  name          = "alias/${local.resource_prefix}-kms"
  target_key_id = aws_kms_key.artifactory.key_id
}

resource "aws_kms_grant" "artifactory_grant" {
  name              = "${local.resource_prefix}-kms-grant"
  key_id            = aws_kms_key.artifactory.key_id
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

  statement {
    sid    = "Allow Cloudwatch Logs access for encrypted logs"
    effect = "Allow"

    principals {
      type = "Service"
      identifiers = [
        "logs.${var.region}.amazonaws.com"
      ]
    }

    resources = ["*"]

    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*"
    ]

    condition {
      test     = "ArnEquals"
      variable = "kms:EncryptionContext:aws:logs:arn"
      values   = ["arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:${local.resource_prefix}"]
    }
  }
}

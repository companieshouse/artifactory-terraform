resource "aws_iam_instance_profile" "artifactory" {
  name = "${local.resource_prefix}-iam-profile"
  role = aws_iam_role.artifactory.name
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ssm_service" {
  statement {
    sid       = "SSMKMSOperations"
    effect    = "Allow"
    resources = [local.security_kms_keys_data["session-manager-kms-key-arn"]]
    actions = [
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:GenerateDataKey*",
      "kms:ReEncrypt*"
    ]
  }

  statement {
    sid    = "SSMS3Operations"
    effect = "Allow"
    resources = [
      "arn:aws:s3:::${local.security_s3_buckets_data["session-manager-bucket-name"]}",
      "arn:aws:s3:::${local.security_s3_buckets_data["session-manager-bucket-name"]}/*"
    ]
    actions = [
      "s3:GetEncryptionConfiguration",
      "s3:PutObject",
      "s3:PutObjectACL"
    ]
  }
}

data "aws_iam_policy_document" "kms_key" {
  statement {
    sid       = "AllowKmsOperations"
    effect    = "Allow"
    resources = [aws_kms_key.artifactory.arn]
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:CreateGrant",
      "kms:ListGrants",
      "kms:RevokeGrant"
    ]
  }
}

data "aws_iam_policy_document" "ssm_parameters" {
  statement {
    sid    = "AllowAccessToSsmParameters"
    effect = "Allow"

    resources = [
      "arn:aws:ssm:${var.region}:${local.account_id}:parameter/${var.service}/${var.environment}/*"
    ]

    actions = [
      "ssm:GetParametersByPath"
    ]
  }
}

resource "aws_iam_role" "artifactory" {
  name               = "${local.resource_prefix}-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy" "ssm_service_core" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

data "aws_iam_policy" "efs_service_core" {
  arn = "arn:aws:iam::aws:policy/AmazonElasticFileSystemFullAccess"
}

data "aws_iam_policy" "cloudwatch_managed" {
  arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_policy" "kms_key" {
  name        = "${local.resource_prefix}-kms-policy"
  description = "${local.resource_prefix} KMS policy"
  policy      = data.aws_iam_policy_document.kms_key.json
}

resource "aws_iam_policy" "ssm_parameters" {
  name        = "${local.resource_prefix}-ssm-parameters-policy"
  description = "${local.resource_prefix} SSM Parameters policy"
  policy      = data.aws_iam_policy_document.ssm_parameters.json
}

resource "aws_iam_role_policy" "ssm_service" {
  name   = "${local.resource_prefix}-ssm-iam-policy"
  role   = aws_iam_role.artifactory.id
  policy = data.aws_iam_policy_document.ssm_service.json
}

resource "aws_iam_role_policy_attachment" "ssm_service_core" {
  role       = aws_iam_role.artifactory.name
  policy_arn = data.aws_iam_policy.ssm_service_core.arn
}

resource "aws_iam_role_policy_attachment" "efs_service_core" {
  role       = aws_iam_role.artifactory.name
  policy_arn = data.aws_iam_policy.efs_service_core.arn
}

resource "aws_iam_role_policy_attachment" "kms_key" {
  role       = aws_iam_role.artifactory.name
  policy_arn = aws_iam_policy.kms_key.arn
}

resource "aws_iam_role_policy_attachment" "ssm_parameters" {
  role       = aws_iam_role.artifactory.name
  policy_arn = aws_iam_policy.ssm_parameters.arn
}

resource "aws_iam_role_policy_attachment" "cloudwatch_managed" {
  role       = aws_iam_role.artifactory.name
  policy_arn = data.aws_iam_policy.cloudwatch_managed.arn
}

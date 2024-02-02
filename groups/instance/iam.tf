resource "aws_iam_instance_profile" "artifactory_instance_profile" {
  name = "${var.service}-${var.environment}-iam-profile"
  role = aws_iam_role.artifactory_instance_role.name
} 

data "aws_iam_policy_document" "iam_instance_policy" {
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
    actions   = [
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:GenerateDataKey*",
      "kms:ReEncrypt*"
    ]
  }

  statement {
    sid       = "SSMS3Operations"
    effect    = "Allow"
    resources = [
      "arn:aws:s3:::${local.security_s3_buckets_data["session-manager-bucket-name"]}",
      "arn:aws:s3:::${local.security_s3_buckets_data["session-manager-bucket-name"]}/*"
    ]
    actions   = [
      "s3:GetEncryptionConfiguration",
      "s3:PutObject",
      "s3:PutObjectACL"
    ]
  }
}

data "aws_iam_policy_document" "kms_key" {
  statement {
    sid       = "AllowKMSOperations"
    effect    = "Allow"
    resources = [
      aws_kms_key.artifactory_kms_key.arn
    ]
    actions   = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
  }
}

resource "aws_iam_role" "artifactory_instance_role" {
  name               = "${var.service}-${var.environment}-ssm-iam-role"
  assume_role_policy = data.aws_iam_policy_document.iam_instance_policy.json
}

data "aws_iam_policy" "ssm_service_core" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

data "aws_iam_policy" "efs_service_core" {
  arn = "arn:aws:iam::aws:policy/AmazonElasticFileSystemFullAccess"
}

resource  "aws_iam_policy" "kms_policy" {
  name        = "${var.service}-${var.environment}-kms-policy"
  description = "${var.service}-${var.environment}-dedicated-kms-key"
  policy      = data.aws_iam_policy_document.kms_key.json
}

resource "aws_iam_role_policy" "artifactory_instance_policy" {
  name   = "${var.service}-${var.environment}-ssm-iam-policy"
  role   = aws_iam_role.artifactory_instance_role.id
  policy = data.aws_iam_policy_document.ssm_service.json
}

resource "aws_iam_role_policy_attachment" "ssm_service_policy_attachment" {
  role       = aws_iam_role.artifactory_instance_role.name
  policy_arn = data.aws_iam_policy.ssm_service_core.arn
}

resource "aws_iam_role_policy_attachment" "efs_policy_attachment" {
  role       = aws_iam_role.artifactory_instance_role.name
  policy_arn = data.aws_iam_policy.efs_service_core.arn
}

resource "aws_iam_role_policy_attachment" "kms_policy_attachment" {
  role       = aws_iam_role.artifactory_instance_role.name
  policy_arn = aws_iam_policy.kms_policy.arn
}

// ---------------------------------------------------------------------------
// Instance IAM Profile
// ---------------------------------------------------------------------------
resource "aws_iam_instance_profile" "artifactory_instance_profile" {
  name = "${var.service}-${var.environment}-iam-profile"
  role = aws_iam_role.artifactory_instance_role.name
} 

// ---------------------------------------------------------------------------
// IAM Policy Documents
// ---------------------------------------------------------------------------
data "aws_iam_policy_document" "iam_instance_policy" {
  statement {
    effect = "Allow"

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

// ---------------------------------------------------------------------------
// Instance IAM Policy
// ---------------------------------------------------------------------------
data "aws_iam_policy" "ssm_service_core" {
  arn   = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

// ---------------------------------------------------------------------------
// Instance IAM Role
// ---------------------------------------------------------------------------
resource "aws_iam_role" "artifactory_instance_role" {
  name               = "${var.service}-${var.environment}-ssm-iam-role"
  assume_role_policy = data.aws_iam_policy_document.iam_instance_policy.json
}

// ---------------------------------------------------------------------------
// Instance IAM Role Policies
// ---------------------------------------------------------------------------
resource "aws_iam_role_policy" "artifactory_instance_policy" {
  name        = "${var.service}-${var.environment}-ssm-iam-policy"
  role        = aws_iam_role.artifactory_instance_role.id
  policy      = data.aws_iam_policy_document.ssm_service.json
}

// ---------------------------------------------------------------------------
// Instance IAM Role Policy Attachments
// ---------------------------------------------------------------------------
resource "aws_iam_role_policy_attachment" "ssm_service_policy_attachment" {
  role       = aws_iam_role.artifactory_instance_role.name
  policy_arn = data.aws_iam_policy.ssm_service_core.arn
}

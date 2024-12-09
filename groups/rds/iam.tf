data "aws_iam_policy_document" "monitoring" {
  statement {
    sid = "ManageLogGroups"
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:PutRetentionPolicy"
    ]
    resources = [
      "${local.rds_cloudwatch_logs_arn_prefix}:log-group:RDS*"
    ]
  }

  statement {
    sid = "CreateRDSLogStreams"
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams",
      "logs:GetLogEvents"
    ]
    resources = [
      "${local.rds_cloudwatch_logs_arn_prefix}:log-group:RDS*:log-stream:*"
    ]
  }
}

data "aws_iam_policy_document" "assume" {
  statement {
    sid = "AllowRDSAssume"
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type        = "Service"
      identifiers = [
        "monitoring.rds.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "monitoring" {
  name               = "${local.resource_prefix}-rds-monitoring"
  assume_role_policy = data.aws_iam_policy_document.assume.json

  tags = {
    Name = "${local.resource_prefix}-rds-monitoring"
  }
}

resource "aws_iam_policy" "monitoring" {
  name        = "${local.resource_prefix}-rds-monitoring"
  description = "${local.resource_prefix} RDS Monitoring"
  policy      = data.aws_iam_policy_document.monitoring.json
}

resource "aws_iam_role_policy_attachment" "monitoring" {
  role       = aws_iam_role.monitoring.name
  policy_arn = aws_iam_policy.monitoring.arn
}

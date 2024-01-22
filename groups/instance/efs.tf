resource "aws_efs_file_system" "efs_file_system" {
  creation_token   = "${var.environment}-${var.service}-efs-token"
  performance_mode = "generalPurpose"
  throughput_mode  = "elastic"
  encrypted        = true
  kms_key_id       = local.efs_kms_key_id

  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }

  tags = {
    Name = "${var.environment}-${var.service}-efs"
  }
}

resource "aws_efs_access_point" "efs_access_point" {
  file_system_id = aws_efs_file_system.efs_file_system.id
}

resource "aws_efs_mount_target" "efs_mount_target" {
  file_system_id  = aws_efs_file_system.efs_file_system.id
  subnet_id       = tolist(data.aws_subnet_ids.placement.ids)[0]  
  security_groups = [ aws_security_group.efs_security_group.id ]

  depends_on      = [ aws_efs_file_system.efs_file_system, ]
}

resource "aws_efs_file_system_policy" "efs_policy" {
  file_system_id = aws_efs_file_system.efs_file_system.id
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Id": "${var.service}-${var.environment}-efs-policy",
    "Statement": [
        {
            "Sid": "Statement",
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Resource": "${aws_efs_file_system.efs_file_system.arn}",
            "Action": [
                "elasticfilesystem:ClientMount",
                "elasticfilesystem:ClientRootAccess",
                "elasticfilesystem:ClientWrite"
            ],
            "Condition": {
                "Bool": {
                    "aws:SecureTransport": "true"
                }
            }
        }
    ]
}
POLICY
}

# ------------------------------------------------------------------------------
# Terraform modules EFS TEST
# ------------------------------------------------------------------------------
module "efs_file_system" {

  source           = "git@github.com:companieshouse/terraform-modules//aws/efs?ref=<version>"
  environment      = var.environment
  service          = var.efs_module_test_service

  vpc_id           = data.aws_vpc.placement.id
  subnet_ids       = tolist(data.aws_subnet_ids.placement.ids)[0]

  kms_key_arn      = local.efs_kms_key_id
  throughput_mode  = "elastic"
  performance_mode = "generalPurpose"

  access_points = {
    artifacts = {
      permissions    = "0755"
      posix_user_gid = 991
      posix_user_uid = 991
      root_directory = "/efs_module_artifacts_test"   
    }
  }
}

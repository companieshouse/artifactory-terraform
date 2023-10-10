// -----------------------------------------------------------------
// Creating the EFs file system
// -----------------------------------------------------------------

resource "aws_efs_file_system" "efs_file_system" {
  name             = "${var.environment}-${var.service}-efs"
  creation_token   = "${var.environment}-${var.service}-efs-token"
  performance_mode = "generalpurpose"
  throughput_mode  = "elastic"
  
  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }

  tags = {
    Name = "${var.environment}-${var.service}-efs"
  }
}

// -----------------------------------------------------------------
// Creating EFS mount target
// -----------------------------------------------------------------

resource "aws_efs_access_point" "efs_access_point" {
  file_system_id = aws_efs_file_system.efs_file_system.id
}

// -----------------------------------------------------------------
// Creating EFS mount target
// -----------------------------------------------------------------

resource "aws_efs_mount_target" "efs_mount_target" {
  file_system_id  = aws_efs_file_system.efs_file_system.id
  subnet_id       = tolist(data.aws_subnet_ids.placement.ids)[0]  
  security_groups = [ aws_security_group.efs_security_group.id ]

  depends_on      = [ aws_efs_file_system.efs_file_system, ]
}

// -----------------------------------------------------------------
// Creating EFS file system policy
// -----------------------------------------------------------------
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
                    "aws:SecureTransport": "false"
                }
            }
        }
    ]
}
POLICY
}
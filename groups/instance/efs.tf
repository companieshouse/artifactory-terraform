module "efs_file_system" {

  source                    = "git@github.com:companieshouse/terraform-modules//aws/efs?ref=1.0.249"
  environment               = var.environment
  service                   = var.service
  permit_client_root_access = var.efs_permit_client_root_access

  vpc_id                    = data.aws_vpc.placement.id
  subnet_ids                = data.aws_subnets.placement.ids

  kms_key_arn               = aws_kms_key.artifactory_kms_key.arn
  throughput_mode           = "elastic"
  performance_mode          = "generalPurpose"

  access_points = {
    "${var.efs_artifacts_access_point_name}" = {  
      permissions    = "0755"
      posix_user_gid = 986
      posix_user_uid = 991
      root_directory = "/${var.efs_artifacts_access_point_name}"   
    }
  }
  
  depends_on = [
    aws_kms_key.artifactory_kms_key
  ]
}

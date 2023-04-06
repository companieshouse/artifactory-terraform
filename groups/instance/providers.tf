provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Environment = var.environment
      Team        = var.team
      Service     = var.service
    }
  }
}

provider "artifactory" {
  url          = "${aws_route53_record.instance.name}:8081/artifactory"
  access_token = local.artifactory_access_token
  check_license = false  # TODO Should be true when license is available
}

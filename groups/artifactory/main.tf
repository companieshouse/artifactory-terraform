terraform {
  required_version = ">= 0.13.0, < 0.14"

  #required_providers {
    #artifactory = {
      #source = "jfrog/artifactory"
      #version = "7.4.3"
    #}
  #}

  backend "s3" {}
}

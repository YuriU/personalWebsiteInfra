# Default instance of provider
provider "aws" {
}

terraform {
    # Optional
    # Terraform backend configuration. The state is stored in S3 bucket
    # The actions to do are calculated from a diff of current infra and backend state
    # Is read on the very early stage, so using variables are not allowed
    backend "s3" {
        key = "personalWebsite_Zone/state.tfstate"
    }
}


resource "aws_route53_zone" "web_site_zone" {
  name = "${var.website_name}"
  force_destroy = true
}
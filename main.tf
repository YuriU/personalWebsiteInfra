# Default instance of provider
provider "aws" {
}

# Region where certificates must be created. 
# CloudFront see with certificates created in N.Virginia region only
provider "aws" {
  region = "us-east-1"
  alias = "certificateEligibleRegion"
}

terraform {
    # Optional
    # Terraform backend configuration. The state is stored in S3 bucket
    # The actions to do are calculated from a diff of current infra and backend state
    # Is read on the very early stage, so using variables are not allowed
    backend "s3" {
        bucket = "jerryhire8test1-terraform-state-storage-bucket"
        key = "personalWebsite/state.tfstate"
        region = "eu-central-1"
        dynamodb_table = "personalWebsite_deploy_lock"
    }
}

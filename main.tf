provider "aws" {
    region = "eu-central-1"	
}

terraform {
    backend "s3" {
        bucket = "jerryhire8test1-terraform-state-storage-bucket"
        key = "personalWebsite/state.tfstate"
        region = "eu-central-1"
        dynamodb_table = "personalWebsite_deploy_lock"
    }
}

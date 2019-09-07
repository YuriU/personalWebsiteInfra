variable "website_name" {
    description = "The name of the website (Must be S3 name compatible)"
}
variable "codepipeline_github_repository_owner" {
  description = "Github repository owner"
}

variable "codepipeline_github_repository" {
  description = "Github repository"
}

variable "codepipeline_github_repository_branch" {
  description = "Github repository branch"
}

variable "codepipeline_github_token" {
    description = "Token to Github repository"
}
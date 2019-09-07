variable "project_name" {
    description = "The name of the project (Must be S3 name compatible)"
    default = "yuriiulianets.dev"
}

variable "codepipeline_github_repository_owner" {
  description = "Github repository owner"
  default = "YuriU"
}

variable "codepipeline_github_repository" {
  description = "Github repository"
  default = "personalWebsite"
}

variable "codepipeline_github_repository_branch" {
  description = "Github repository branch"
  default = "master"
}

variable "codepipeline_github_token" {
    description = "Token to Github repository"
}
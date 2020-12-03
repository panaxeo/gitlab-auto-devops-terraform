variable "namespace" {
  type = string
  validation {
    condition     = var.namespace != ""
    error_message = "The namespae must be non-empty string."
  }
}
variable "name" {
  type = string
  validation {
    condition     = var.name != ""
    error_message = "The name must be non-empty string."
  }
}
variable "data" {
  type = map(string)
  # validation {
  #   condition     = var.gitlab_deploy_password != ""
  #   error_message = "The gitlab_deploy_password must be non-empty string. Make sure You have gitlab-deploy-token created in project. See https://docs.gitlab.com/ee/user/project/deploy_tokens/#gitlab-deploy-token for more info."
  # }
}
variable "type" {
  type    = string
  default = null
}

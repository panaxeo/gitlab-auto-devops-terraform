variable "namespace" {
  type = string
  validation {
    condition     = var.namespace != ""
    error_message = "The namespae must be non-empty string."
  }
}
variable "gitlab" {
  type = object({
    secrets         = map(string)
    deploy_user     = string
    deploy_password = string
  })
}

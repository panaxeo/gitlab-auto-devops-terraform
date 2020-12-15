variable "gitlab" {
  type = object({
    secrets         = map(string)
    ci_deploy_user     = string
    ci_deploy_password = string
    kube_namespace = string
  })
}

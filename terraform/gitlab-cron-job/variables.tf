variable "gitlab" {
  type = object({
    secrets              = map(string)
    ci_project_name      = string
    ci_project_path_slug = string
    ci_environment_slug  = string
    ci_registry_image    = string
    ci_commit_short_sha  = string
    kube_namespace       = string
  })
}

variable "namespace" {
  type    = string
  default = ""
}
variable "name" {
  type    = string
  default = ""
}
variable "schedule" {}
variable "container_image" {
  default = ""
}
variable "container_name" {
  default = "main"
}
variable "container_command" {
  default = null
  type    = list(string)
}


variable "env" {
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}
variable "secrets" {
  type = list(object({
    name        = string
    secret_name = string
    secret_key  = string
  }))
  default = []
}

variable "resources" {
  type = object({
    requests = object({
      cpu    = string
      memory = string
    })
    limits = object({
      cpu    = string
      memory = string
    })
  })
  default = {
    requests = {
      cpu    = "0.1"
      memory = "128Mi"
    }
    limits = {
      cpu    = "0.2"
      memory = "256Mi"
    }
  }
  description = "Container resources requests/limits configuration"
}

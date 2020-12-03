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
variable "schedule" {}
variable "container_image" {}
variable "container_name" {
  default = "main"
}
variable "container_command" {
  default = null
  type = list(string)
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
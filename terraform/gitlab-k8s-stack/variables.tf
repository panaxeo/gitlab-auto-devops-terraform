variable "container_name" {
  default = "main"
}
variable "container_image" {}
variable "container_port" {
  default = 80
}
variable "hostname" {
  type    = string
  default = null
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

variable "liveness_probe" {
  type = object({
    path = string
  })
  default = {
    path = "/healthcheck"
  }
  description = "Liveliness probe configuration"
}
variable "readiness_probe" {
  type = object({
    path = string
  })
  default = {
    path = "/healthcheck"
  }
  description = "Readiness probe configuration"
}

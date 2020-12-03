resource "kubernetes_service" "main" {
  metadata {
    name      = local.service_name
    namespace = var.namespace
  }

  spec {
    selector = {
      name      = var.name
      namespace = var.namespace
    }

    port {
      port        = 80
      target_port = var.container_port
    }
  }
}

resource "kubernetes_deployment" "main" {
  metadata {
    name      = var.name
    namespace = var.namespace
  }

  wait_for_rollout = true

  spec {
    selector {
      match_labels = {
        name      = var.name
        namespace = var.namespace
      }
    }

    template {
      metadata {
        labels = {
          name      = var.name
          namespace = var.namespace
        }
      }

      spec {
        container {
          name  = var.container_name
          image = var.container_image

          port {
            container_port = var.container_port
          }

          dynamic "env" {
            for_each = var.env
            content {
              name  = env.value["name"]
              value = env.value["value"]
            }
          }

          dynamic "env" {
            for_each = var.secrets
            content {
              name = env.value["name"]
              value_from {
                secret_key_ref {
                  name = env.value["secret_name"]
                  key  = env.value["secret_key"]
                }
              }
            }
          }

          liveness_probe {
            http_get {
              path = var.liveness_probe.path
              port = var.container_port
            }

            initial_delay_seconds = "10"
            period_seconds        = "10"
          }

          readiness_probe {
            http_get {
              path = var.readiness_probe.path
              port = var.container_port
            }

            initial_delay_seconds = "10"
            period_seconds        = "10"
          }

          resources {
            requests {
              cpu    = var.resources.requests.cpu
              memory = var.resources.requests.memory
            }

            limits {
              cpu    = var.resources.limits.cpu
              memory = var.resources.limits.memory
            }
          }
        }

        image_pull_secrets {
          name = "gitlab-registry"
        }
      }
    }
  }
}

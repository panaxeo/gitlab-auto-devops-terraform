resource "kubernetes_deployment" "main" {
  metadata {
    name      = local.name
    namespace = var.gitlab.kube_namespace
    annotations = {
      "app.gitlab.com/app" = var.gitlab.ci_project_path_slug
      "app.gitlab.com/env" = var.gitlab.ci_environment_slug
    }
  }

  wait_for_rollout = true 

  spec {
    selector {
      match_labels = {
        name      = local.name
        namespace = var.gitlab.kube_namespace
      }
    }

    template {
      metadata {
        labels = {
          name      = local.name
          namespace = var.gitlab.kube_namespace
        }
        annotations = {
          "app.gitlab.com/app" = var.gitlab.ci_project_path_slug
          "app.gitlab.com/env" = var.gitlab.ci_environment_slug
        }
      }

      spec {
        container {
          name  = var.container_name
          image = var.container_image != "" ? var.container_image : "${var.gitlab.ci_registry_image}:${var.gitlab.ci_commit_short_sha}"

          port {
            container_port = var.container_port
          }

          dynamic "security_context" {
            for_each = var.security_context == null ? [] : [1]
            content {
              allow_privilege_escalation = var.security_context.allow_privilege_escalation
              run_as_user = var.security_context.run_as_user
            }
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

            initial_delay_seconds = "60"
            period_seconds        = "10"
          }

          readiness_probe {
            http_get {
              path = var.readiness_probe.path
              port = var.container_port
            }

            initial_delay_seconds = "60"
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

          dynamic "volume_mount" {
            for_each = var.persistent_volume == null ? [] : [1]
            content {
              name = local.name
              mount_path = var.persistent_volume.path
            }
          }
        }

        dynamic "volume" {
          for_each = var.persistent_volume == null ? [] : [1]
          content {
            name = local.name
            persistent_volume_claim {
              claim_name = local.name
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

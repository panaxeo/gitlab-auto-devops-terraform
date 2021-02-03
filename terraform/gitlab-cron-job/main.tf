resource "kubernetes_cron_job" "main" {
  metadata {
    name      = local.name
    namespace = var.gitlab.kube_namespace
    annotations = {
      "app.gitlab.com/app" = var.gitlab.ci_project_path_slug
      "app.gitlab.com/env" = var.gitlab.ci_environment_slug
    }
  }
  spec {
    concurrency_policy            = "Forbid"
    failed_jobs_history_limit     = 5
    schedule                      = var.schedule
    starting_deadline_seconds     = 10
    successful_jobs_history_limit = 10
    job_template {
      metadata {
        annotations = {
          "app.gitlab.com/app" = var.gitlab.ci_project_path_slug
          "app.gitlab.com/env" = var.gitlab.ci_environment_slug
        }
      }
      spec {
        backoff_limit              = 2
        ttl_seconds_after_finished = 10
        template {
          metadata {
            annotations = {
              "app.gitlab.com/app" = var.gitlab.ci_project_path_slug
              "app.gitlab.com/env" = var.gitlab.ci_environment_slug
            }
          }
          spec {
            container {
              name    = var.container_name
              image   = var.container_image != "" ? var.container_image : "${var.gitlab.ci_registry_image}:${var.gitlab.ci_commit_short_sha}"
              command = var.container_command

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
  }
}

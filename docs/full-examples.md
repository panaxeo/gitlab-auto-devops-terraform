# Full examples

Following snippets shows full examples of terraform modules.

### App stack

Following stack shows real example of grafana deployment

```
module "k8s-app" {
  source = "git::https://github.com/panaxeo/gitlab-auto-devops-terraform//terraform/gitlab-k8s-stack"
  gitlab = var.gitlab

  # we are overriding the container image and port as required by grafana image
  container_image = "grafana/grafana"
  container_port = 3000

  secrets = [{
    name        = "GF_DATABASE_URL"
    secret_name = "gitlab-secrets"
    secret_key  = "GF_DATABASE_URL"
  }]

  env = [{
    name  = "GF_SERVER_ROOT_URL"
    value = var.gitlab.ci_environment_url
  }]

  liveness_probe = {
    path = "/api/health"
  }
  readiness_probe = {
    path = "/api/health"
  }

  resources = {
    requests = {
      cpu    = "0.1"
      memory = "256Mi"
    }
    limits = {
      cpu    = "0.2"
      memory = "512Mi"
    }
  }
}

```

### Cron job

Following stack shows real example of how cron job with slack notifier could look like:

```
module "k8s-cron-job" {
  source = "git::https://github.com/panaxeo/gitlab-auto-devops-terraform//terraform/gitlab-cron-job"
  gitlab = var.gitlab

  schedule = "*/5 * * * *"

  secrets = [{
    name        = "SLACK_URL"
    secret_name = "gitlab-secrets"
    secret_key  = "SLACK_URL"
  }]

  env = [{
    name  = "SLACK_CHANNEL"
    value = "notification-test"
  }]

  resources = {
    requests = {
      cpu    = "0.1"
      memory = "128Mi"
    }
    limits = {
      cpu    = "0.2"
      memory = "256Mi"
    }
  }
}

```

locals {
  name     = var.name == "" ? var.gitlab.ci_project_name : var.name
  environment_hostname = var.gitlab.ci_environment_url != null ? replace(var.gitlab.ci_environment_url, "https://", "") : null
  hostname = var.hostname != "" ? var.hostname : ( locals.environment_hostname )
}

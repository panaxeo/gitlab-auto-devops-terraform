locals {
  name         = var.name == "" ? var.gitlab.ci_project_name : var.name
  service_name = var.name == "" ? var.gitlab.ci_project_name : var.name
}

locals {
  name = var.name == "" ? var.gitlab.ci_project_name : var.name
}

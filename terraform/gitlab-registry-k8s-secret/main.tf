locals {
  secret_name = "gitlab-registry"
  dockercfg = {
    auths = {
      "registry.gitlab.com" = {
        "username" = var.gitlab.ci_deploy_user
        "password" = var.gitlab.ci_deploy_password
        "auth"     = base64encode("${var.gitlab.ci_deploy_user}:${var.gitlab.ci_deploy_password}")
      }
    }
  }
}

resource "kubernetes_secret" "gitlab_registry" {
  type = "kubernetes.io/dockerconfigjson"

  metadata {
    name      = local.secret_name
    namespace = var.gitlab.kube_namespace
  }

  data = {
    ".dockerconfigjson" = jsonencode(local.dockercfg)
  }
}

resource "kubernetes_secret" "gitlab_secrets" {
  type = "opaque"

  metadata {
    name      = "gitlab-secrets"
    namespace = var.gitlab.kube_namespace
  }

  data = var.gitlab.secrets
}



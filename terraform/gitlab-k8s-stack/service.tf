resource "kubernetes_service" "main" {
  metadata {
    name      = local.name
    namespace = var.gitlab.kube_namespace
  }

  spec {
    selector = {
      name      = local.name
      namespace = var.gitlab.kube_namespace
    }

    port {
      port        = 80
      target_port = var.container_port
    }
  }
}

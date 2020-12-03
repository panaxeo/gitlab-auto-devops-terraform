resource "kubernetes_secret" "main" {
  metadata {
    name      = var.name
    namespace = var.namespace
  }
  data = var.data
  type = var.type
}

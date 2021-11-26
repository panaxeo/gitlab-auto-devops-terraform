resource "kubernetes_persistent_volume_claim" "storage" {
  count = var.persistent_volume == null ? 0 : 1
  metadata {
    name = local.name
    namespace = var.gitlab.kube_namespace
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = var.persistent_volume.size
      }
    }
    storage_class_name = var.persistent_volume.storage_class_name
  }
}
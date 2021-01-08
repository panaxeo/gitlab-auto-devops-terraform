resource "kubernetes_ingress" "main" {
  count = var.hostname != null ? 1 : 0
  metadata {
    name      = local.name
    namespace = var.gitlab.kube_namespace

    annotations = {
      #   "nginx.ingress.kubernetes.io/rewrite-target" = "/"  #   "nginx.ingress.kubernetes.io/add-base-url"   = true

      "nginx.ingress.kubernetes.io/rewrite-target" = "/$1"
      "nginx.ingress.kubernetes.io/use-regex"      = "true"

      "certmanager.k8s.io/cluster-issuer"        = "letsencrypt"
      "nginx.ingress.kubernetes.io/ssl-redirect" = "false"
      # "nginx.ingress.kubernetes.io/proxy-body-size" = "50m"
      # "nginx.ingress.kubernetes.io/enable-cors"     = "true"
    }
  }

  spec {
    rule {
      host = var.hostname

      http {
        path {
          path = "/(.*)"

          backend {
            service_name = local.name
            service_port = 80
          }
        }
      }
    }

    tls {
      hosts = [
        var.hostname
      ]
      secret_name = "${local.name}-cert"
    }
  }
}

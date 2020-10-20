resource kubernetes_namespace ins-namespace {
   metadata {
     name = "cert-manager"
   }
}
resource helm_release ins-cert-manager {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  namespace        = "cert-manager"
  set {
    name  = "installCRDs"
    value = "true"
  } 
}
resource null_resource wait {
  provisioner local-exec {
    command = "sleep 120"
  }
}

resource helm_release ins-cluster-issuer {
  depends_on = [ null_resource.wait ]

  name      = "certs"
  namespace = "cert-manager"
  chart     = "${path.module}/certs"

  force_update    = true
  cleanup_on_fail = true
  recreate_pods   = false
  reset_values    = false

  values = [local.helm_chart_values]
}


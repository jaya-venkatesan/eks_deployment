resource kubernetes_namespace ins-namespace {
   metadata {
     name = "ingress-nginx"
   }
}
resource helm_release ins-ingress-nginx {
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress-nginx"
  
}

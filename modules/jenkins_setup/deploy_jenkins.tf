data "kubernetes_service" "instance" {
  metadata {
    name      = "ingress-nginx-controller"
    namespace = "ingress-nginx"
  }
}
resource kubernetes_namespace ins-namespace {
   metadata {
     name = "jenkins"
   }
}
locals {
  pass_set = base64decode("RHJ0ejNtZVlvRA==")
}
resource helm_release ins-jenkins {
  name             = "jenkins"
  repository       = "https://charts.jenkins.io"
  chart            = "jenkins"
  namespace        = "jenkins"
  set {
    name  = "master.adminPassword"
    value = "${local.pass_set}"
  }
  set {
    name  = "master.jenkinsUriPrefix"
    value = "/jenkins"
  } 
  set {
    name  = "master.ingress.enabled"
    value = "true"
  }
  set {
    name  = "master.ingress.annotations.kubernetes\\.io/ingress\\.class"
    value = "nginx"
  }
  set {
    name  = "master.ingress.annotations.cert-manager\\.io/cluster-issuer"
    value = "letsencrypt-${var.environment}"
  }
  set {
    name  = "master.ingress.annotations.path"
    value = "/jenkins"
  }
  set {
    name  = "master.ingress.hostName"
    value = "${data.kubernetes_service.instance.load_balancer_ingress.0.hostname}"
  }
  set {
    name  = "master.ingress.tls[0].secretName"
    value = "letsencrypt-${var.environment}"
  }
  set {
    name  = "master.ingress.tls[0].hosts"
    value = "{jenkins.cluster.local}"
  }


}


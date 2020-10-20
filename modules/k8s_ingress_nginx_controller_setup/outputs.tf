data "kubernetes_service" "instance" {
  metadata {
    name      = "ingress-nginx-controller"
    namespace = "ingress-nginx"
  }
  depends_on = [ helm_release.ins-ingress-nginx ] 
}
output "load_balancer_name" {
  description = "nginx ingress controller external host name"
  value       = data.kubernetes_service.instance.load_balancer_ingress.0.hostname
}

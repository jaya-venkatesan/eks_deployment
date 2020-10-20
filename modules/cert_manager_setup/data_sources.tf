locals {
  template_vars = {
    project = var.project,
    env     = var.environment,
    name    = "letsencrypt-${var.environment}",
    email   = var.email
  }
  helm_chart_values = templatefile(
    "${path.module}/certs/values.yaml.tpl",
    local.template_vars
  )
}

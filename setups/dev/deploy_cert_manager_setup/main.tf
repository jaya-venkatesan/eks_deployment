module cert_manager_setup {
  source      = "../../../modules/cert_manager_setup"
  project     = var.project
  environment = local.env
  email       = var.email
}

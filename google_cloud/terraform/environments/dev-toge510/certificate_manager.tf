module "certificate_manager_module" {
  source       = "../../../terraform/modules/certificate_manager/"
  name         = "toge5103-com"
  domain       = "toge5103.com"
  managed_zone = google_dns_managed_zone.toge5103_com_zone.name
  project      = "dev-toge510"
}
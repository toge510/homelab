resource "google_certificate_manager_certificate_map" "certificate_map" {
  name        = "dev-toge510-cert-map"
  description = "dev-toge510 certificate map"
}

module "certificate_manager_module" {
  source       = "../../../terraform/modules/certificate_manager/"
  name         = "toge5103-com"
  domain       = "toge5103.com"
  managed_zone = google_dns_managed_zone.toge5103_com_zone.name
  project      = "dev-toge510"
  certificate_map = google_certificate_manager_certificate_map.certificate_map.name
  use_google_cloud_dns = true
  dns_authorization = "toge5103-com-dns-auth"
}

# output "state" {
#   value = module.certificate_manager_module.state
#   description = "state"
# }

# output "provisioning_issue" {
#   value = module.certificate_manager_module.provisioning_issue
#   description = "provisioning_issue"
# }

# output "authorization_attempt_info" {
#   value = module.certificate_manager_module.authorization_attempt_info
#   description = "authorization_attempt_info"
# }
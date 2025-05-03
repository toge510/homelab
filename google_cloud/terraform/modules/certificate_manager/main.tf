resource "google_certificate_manager_dns_authorization" "dns_auth" {
  count       = var.use_google_cloud_dns ? 1 : 0
  name        = "${var.name}-dns-auth"
  description = "DNS authorization for ${var.domain} domain"
  domain      = var.domain
  type        = "PER_PROJECT_RECORD"
}

resource "google_dns_record_set" "dns_record_cname" {
  count        = var.use_google_cloud_dns ? 1 : 0
  name         = google_certificate_manager_dns_authorization.dns_auth[0].dns_resource_record[0].name
  managed_zone = var.managed_zone
  type         = google_certificate_manager_dns_authorization.dns_auth[0].dns_resource_record[0].type
  ttl          = 300
  rrdatas      = [google_certificate_manager_dns_authorization.dns_auth[0].dns_resource_record[0].data]
}

resource "google_certificate_manager_certificate" "wildcard_cert" {
  name        = "${var.name}-wildcard-cert"
  description = "The wildcard cert for ${var.domain} domain"
  managed {
    domains = [var.domain, "*.${var.domain}"]
    dns_authorizations = var.use_google_cloud_dns ? [google_certificate_manager_dns_authorization.dns_auth[0].id] : [var.dns_authorization]
  }
}

# output "state" {
#   value = google_certificate_manager_certificate.wildcard_cert.managed[0].state
#   description = "state"
# }

# output "provisioning_issue" {
#   value = google_certificate_manager_certificate.wildcard_cert.managed[0].provisioning_issue
#   description = "provisioning_issue"
# }

# output "authorization_attempt_info" {
#   value = google_certificate_manager_certificate.wildcard_cert.managed[0].authorization_attempt_info
#   description = "authorization_attempt_info"
# }

# resource "google_certificate_manager_certificate_map_entry" "cert_map_entry" {
#   name         = "${var.name}-cert-map-entry"
#   description  = "${var.name} certificate map entry"
#   map          = var.certificate_map
#   certificates = [google_certificate_manager_certificate.wildcard_cert.id]
#   hostname     = var.domain
# }

# resource "google_certificate_manager_certificate_map_entry" "wildcard_cert_map_entry" {
#   name         = "${var.name}-wildcard-cert-map-entry"
#   description  = "${var.name} wildcard certificate map entry"
#   map          = var.certificate_map
#   certificates = [google_certificate_manager_certificate.wildcard_cert.id]
#   hostname     = "*.${var.domain}"
# }
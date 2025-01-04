resource "google_certificate_manager_dns_authorization" "dns_auth" {
  name        = "${var.name}-dns-auth"
  description = "DNS authorization for ${var.domain} domain"
  domain      = var.domain
  type        = "PER_PROJECT_RECORD"
  labels = {
    "terraform" : true
  }
}

resource "google_dns_record_set" "dns_record_cname" {
  name         = google_certificate_manager_dns_authorization.dns_auth.dns_resource_record[0].name
  managed_zone = var.managed_zone
  type         = google_certificate_manager_dns_authorization.dns_auth.dns_resource_record[0].type
  ttl          = 300
  rrdatas      = [google_certificate_manager_dns_authorization.dns_auth.dns_resource_record[0].data]
}

resource "google_certificate_manager_certificate" "wildcard_cert" {
  name        = "${var.name}-wildcard-cert"
  description = "The wildcard cert for ${var.domain} domain"
  managed {
    domains = [var.domain, "*.${var.domain}"]
    dns_authorizations = [
      google_certificate_manager_dns_authorization.dns_auth.id
    ]
  }
  labels = {
    "terraform" : true
  }
}

resource "google_certificate_manager_certificate_map" "cert_map" {
  name        = "${var.project}-cert-map"
  description = "${var.project} certificate map"
  labels = {
    "terraform" : true
  }
}

resource "google_certificate_manager_certificate_map_entry" "cert_map_entry" {
  name         = "${var.name}-cert-map-entry"
  description  = "${var.name} certificate map entry"
  map          = google_certificate_manager_certificate_map.cert_map.name
  certificates = [google_certificate_manager_certificate.wildcard_cert.id]
  hostname     = var.domain
  labels = {
    "terraform" : true
  }
}

resource "google_certificate_manager_certificate_map_entry" "wildcard_cert_map_entry" {
  name         = "${var.name}-wildcard-cert-map-entry"
  description  = "${var.name} wildcard certificate map entry"
  map          = google_certificate_manager_certificate_map.cert_map.name
  certificates = [google_certificate_manager_certificate.wildcard_cert.id]
  hostname     = "*.${var.domain}"
  labels = {
    "terraform" : true
  }
}
resource "google_certificate_manager_dns_authorization" "toge5103_com_dns_auth" {
  name        = "toge5103-com-dns-auth"
  description = "DNS authorization for toge5103.com domain"
  domain      = "toge5103.com"
  type        = "PER_PROJECT_RECORD"
  labels = {
    "terraform" : true
  }
}

resource "google_dns_record_set" "toge5103_com_dns_record_cname" {
  name         = google_certificate_manager_dns_authorization.toge5103_com_dns_auth.dns_resource_record[0].name
  managed_zone = google_dns_managed_zone.toge5103_com_zone.name
  type         = google_certificate_manager_dns_authorization.toge5103_com_dns_auth.dns_resource_record[0].type
  ttl          = 300
  rrdatas      = [google_certificate_manager_dns_authorization.toge5103_com_dns_auth.dns_resource_record[0].data]
}

resource "google_certificate_manager_certificate" "wildcard_toge5103_com_cert" {
  name        = "wildcard-toge5103-com-cert"
  description = "The wildcard cert for toge5103.com domain"
  managed {
    domains = ["toge5103.com", "*.toge5103.com"]
    dns_authorizations = [
      google_certificate_manager_dns_authorization.toge5103_com_dns_auth.id
    ]
  }
  labels = {
    "terraform" : true
  }
}

resource "google_certificate_manager_certificate_map" "dev_toge510_cert_map" {
  name        = "dev-toge510-cert-map"
  description = "dev-toge510 certificate map"
  labels = {
    "terraform" : true
  }
}

resource "google_certificate_manager_certificate_map_entry" "toge5103_com_cert_map_entry" {
  name        = "toge5103-com-cert-map-entry"
  description = "toge5103.com certificate map entry"
  map         = google_certificate_manager_certificate_map.dev_toge510_cert_map.name
  certificates = [google_certificate_manager_certificate.wildcard_toge5103_com_cert.id]
  hostname     = "toge5103.com"
  labels = {
    "terraform" : true
  }
}

resource "google_certificate_manager_certificate_map_entry" "wildcard_toge5103_com_cert_map_entry" {
  name        = "wildcard-toge5103-com-cert-map-entry"
  description = "wildcard toge5103.com certificate map entry"
  map         = google_certificate_manager_certificate_map.dev_toge510_cert_map.name
  certificates = [google_certificate_manager_certificate.wildcard_toge5103_com_cert.id]
  hostname     = "*.toge5103.com"
  labels = {
    "terraform" : true
  }
}
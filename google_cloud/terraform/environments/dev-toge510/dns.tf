resource "google_dns_managed_zone" "toge5103_com_zone" {
  name        = "toge5103-com"
  dns_name    = "toge5103.com."
  description = "toge5103.com"
}

resource "google_dns_record_set" "dev_toge5103_com_a_record" {
  managed_zone = google_dns_managed_zone.toge5103_com_zone.name
  name         = "dev.toge5103.com."
  type         = "A"
  rrdatas      = ["35.244.202.26"]
  ttl          = 300
}
# resource "google_compute_health_check" "default" {
#   check_interval_sec  = 5
#   description         = "http health check"
#   healthy_threshold   = 2
#   name                = "http-basic-health-check"
#   project             = "dev-toge510"
#   timeout_sec         = 5
#   unhealthy_threshold = 2
#   http_health_check {
#     host               = null
#     port               = 80
#     port_name          = null
#     port_specification = null
#     proxy_header       = "NONE"
#     request_path       = "/"
#     response           = null
#   }
#   log_config {
#     enable = false
#   }
# }

# resource "google_compute_backend_service" "default" {
#   affinity_cookie_ttl_sec         = 0
#   compression_mode                = null
#   connection_draining_timeout_sec = 300
#   custom_request_headers          = []
#   custom_response_headers         = []
#   description                     = null
#   edge_security_policy            = null
#   enable_cdn                      = false
#   health_checks                   = ["https://www.googleapis.com/compute/v1/projects/dev-toge510/global/healthChecks/http-basic-health-check"]
#   load_balancing_scheme           = "EXTERNAL_MANAGED"
#   locality_lb_policy              = "ROUND_ROBIN"
#   name                            = "web-backend-service"
#   port_name                       = "http"
#   project                         = "dev-toge510"
#   protocol                        = "HTTP"
#   security_policy                 = "https://www.googleapis.com/compute/v1/projects/dev-toge510/global/securityPolicies/default-security-policy-for-backend-service-web-backend-service"
#   service_lb_policy               = null
#   session_affinity                = "NONE"
#   timeout_sec                     = 30
#   backend {
#     balancing_mode               = "UTILIZATION"
#     capacity_scaler              = 1
#     description                  = null
#     group                        = "https://www.googleapis.com/compute/v1/projects/dev-toge510/zones/asia-northeast1-a/instanceGroups/lb-backend-example"
#     max_connections              = 0
#     max_connections_per_endpoint = 0
#     max_connections_per_instance = 0
#     max_rate                     = 0
#     max_rate_per_endpoint        = 0
#     max_rate_per_instance        = 0
#     max_utilization              = 0.8
#   }
#   log_config {
#     enable      = false
#     sample_rate = 0
#   }
# }

# resource "google_compute_global_forwarding_rule" "default" {
#   description           = ""
#   ip_address            = "35.244.202.26"
#   ip_protocol           = "TCP"
#   ip_version            = null
#   labels                = {}
#   load_balancing_scheme = "EXTERNAL_MANAGED"
#   name                  = "web-frontend-service"
#   network               = null
#   no_automate_dns_zone  = null
#   port_range            = "443-443"
#   project               = "dev-toge510"
#   source_ip_ranges      = []
#   subnetwork            = null
#   target                = google_compute_target_https_proxy.default.id
# }

# resource "google_compute_url_map" "default" {
#   default_service = google_compute_backend_service.default.name
#   description     = "url map"
#   name            = "web-map-http"
#   project         = "dev-toge510"
# }

# resource "google_compute_target_https_proxy" "default" {
#   name                             = "web-map-https-target-proxy"
#   url_map                          = google_compute_url_map.default.id
#   certificate_map = "//certificatemanager.googleapis.com/projects/dev-toge510/locations/global/certificateMaps/dev-toge510-cert-map"
# }
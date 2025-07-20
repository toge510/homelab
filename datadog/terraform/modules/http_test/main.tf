resource "datadog_synthetics_test" "this" {
  name        = var.name
  type        = "api"
  subtype     = "http"
  status      = "live"
  message     = var.message
  locations   = var.locations
  tags        = var.tags
  device_ids  = []
  request_headers  = {}
  request_metadata = {}
  request_query    = {}
  variables_from_script = null

  assertion {
    operator = "lessThan"
    target   = var.response_time_target
    type     = "responseTime"
  }
  assertion {
    operator = "is"
    target   = var.status_code_target
    type     = "statusCode"
  }

  options_list {
    accept_self_signed              = false
    allow_insecure                  = false
    check_certificate_revocation    = false
    disable_cors                    = false
    disable_csp                     = false
    follow_redirects                = var.follow_redirects
    http_version                    = "any"
    ignore_server_certificate_error = false
    initial_navigation_timeout      = 0
    min_failure_duration            = var.min_failure_duration
    min_location_failed             = var.min_location_failed
    monitor_name                    = "[http test] ${var.name}"
    no_screenshot                   = false
    tick_every                      = var.tick_every
    retry {
      count    = var.retry.count
      interval = var.retry.interval
    }
  }

  request_definition {
    method  = "GET"
    url     = var.url
  }
}

# resource "datadog_synthetics_test" "synthetics_test" {
#   name      = "An Uptime test on toge510.com"
#   type      = "api"
#   subtype   = "http"
#   status    = "live"
#   message   = "Notify @pagerduty"
#   locations = ["aws:ap-northeast-1"]
#   tags      = ["env:aws"]

#   request_definition {
#     method = "GET"
#     url    = "https://toge510.com"
#   }

#   assertion {
#     type     = "statusCode"
#     operator = "is"
#     target   = "200"
#   }

#   options_list {
#     tick_every = 900
#     retry {
#       count    = 3
#       interval = 300
#     }
#   }
# }

# resource "datadog_synthetics_test" "fizz" {
#     device_ids            = []
#     id                    = "uey-wke-xjg"
#     locations             = [
#         "aws:ap-northeast-1",
#     ]
#     message               = "test @slack-datadog-test "
#     monitor_id            = 7372723
#     name                  = "Test on toge510.com"
#     request_headers       = {}
#     request_metadata      = {}
#     request_query         = {}
#     status                = "live"
#     subtype               = "http"
#     tags                  = []
#     type                  = "api"
#     variables_from_script = null

#     assertion {
#         code          = null
#         operator      = "is"
#         property      = null
#         target        = "200"
#         timings_scope = null
#         type          = "statusCode"
#     }
#     assertion {
#         code          = null
#         operator      = "lessThan"
#         property      = null
#         target        = "3000"
#         timings_scope = null
#         type          = "responseTime"
#     }

#     options_list {
#         accept_self_signed              = false
#         allow_insecure                  = false
#         check_certificate_revocation    = false
#         disable_cors                    = false
#         disable_csp                     = false
#         follow_redirects                = true
#         http_version                    = "any"
#         ignore_server_certificate_error = false
#         initial_navigation_timeout      = 0
#         min_failure_duration            = 120
#         min_location_failed             = 1
#         monitor_name                    = "test monitor "
#         monitor_priority                = 0
#         no_screenshot                   = false
#         restricted_roles                = []
#         tick_every                      = 180

#         retry {
#             count    = 3
#             interval = 300
#         }
#     }

# #terraform state show datadog_synthetics_test.fizz

#     request_definition {
#         body                    = null
#         body_type               = null
#         call_type               = null
#         certificate_domains     = []
#         dns_server              = null
#         dns_server_port         = null
#         host                    = null
#         http_version            = null
#         message                 = null
#         method                  = "GET"
#         no_saving_response_body = false
#         number_of_packets       = 0
#         persist_cookies         = false
#         plain_proto_file        = null
#         port                    = null
#         proto_json_descriptor   = null
#         servername              = null
#         service                 = null
#         should_track_hops       = false
#         timeout                 = 0
#         url                     = "https://toge510.com"
#     }
# }
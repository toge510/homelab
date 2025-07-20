module "http_test_toge510" {
  source    = "../modules/http_test"
  name      = "Test on toge510.com"
  url       = "https://toge510.com"
  locations = ["aws:ap-northeast-1"]
  tags      = ["env:aws"]
  message   = "@slack-datadog-test alert"
  response_time_target = 3000
  follow_redirects     = true
  min_failure_duration = 10
  status_code_target   = "200"
  min_location_failed = 1
  tick_every          = 120
  retry = {
    count    = 3
    interval = 3000
  }
}
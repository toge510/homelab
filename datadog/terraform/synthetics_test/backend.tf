terraform {
  backend "gcs" {
    bucket = "terraform-remote-tfstate-backend"
    prefix = "datadog/synthetics_test"
  }
}
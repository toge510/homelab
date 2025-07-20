terraform {
  required_version = ">= 1.8.5"
  required_providers {
    datadog = {
      source = "DataDog/datadog"
      version = "3.61.0"
    }
  }
}
variable "name" {
  description = "The name of the synthetics test"
  type        = string
}

variable "url" {
  description = "The URL to test"
  type        = string
}

variable "locations" {
  description = "Locations to run the test from"
  type        = list(string)
}

variable "tags" {
  description = "Tags for the test"
  type        = list(string)
}

variable "message" {
  description = "Alert message for the test"
  type        = string
}

# assersion target response time
variable "response_time_target" {
  description = "Target response time"
  type        = number
}

# assersion target status code

variable "min_location_failed" {
  description = "Minimum location failed for the test."
  type        = number
}

variable "tick_every" {
  description = "Interval in seconds between test runs."
  type        = number
}

variable "retry" {
  description = "Retry configuration for the test."
  type = object({
    count    = number
    interval = number
  })
}

variable "follow_redirects" {
  description = "Whether to follow HTTP redirects."
  type        = bool
  default     = false
}

variable "min_failure_duration" {
  description = "Minimum failure duration in seconds."
  type        = number
  default     = 0
}

variable "status_code_operator" {
  description = "Operator for status code assertion."
  type        = string
  default     = "is"
}

variable "status_code_target" {
  description = "Target status code for assertion."
  type        = string
  default     = "200"
}
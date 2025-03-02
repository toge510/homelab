variable "name" {
  description = "The base name for the resources"
  type        = string
}

variable "domain" {
  description = "The domain name for DNS authorization and certificates"
  type        = string
}

variable "managed_zone" {
  description = "The name of the DNS managed zone"
  type        = string
}

variable "project" {
  description = "The name of the project where the resources will be created"
  type        = string
}

variable "certificate_map" {
  description = "certificate_map"
  type        = string
}

variable "use_google_cloud_dns" {
  description = "Use google cloud for DNS authorization"
  type        = bool
}

variable "dns_authorization" {
  description = "DNS authorization for AWS"
  type        = string
}
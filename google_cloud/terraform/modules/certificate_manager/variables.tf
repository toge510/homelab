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
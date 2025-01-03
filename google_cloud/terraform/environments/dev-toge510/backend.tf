terraform {
  backend "gcs" {
    bucket = "terraform-remote-tfstate-backend"
    prefix = "dev-toge510"
  }
}
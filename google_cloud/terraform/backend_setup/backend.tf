terraform {
  backend "gcs" {
    bucket = "terraform-remote-tfstate-backend"
    prefix = "backend_setup"
  }
}
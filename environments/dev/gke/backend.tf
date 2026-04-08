terraform {
  backend "gcs" {
    bucket = "terraform-aqueous-scout-444117-j2"
    prefix = "terraform/state/dev/gke"
  }
}

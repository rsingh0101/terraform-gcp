terraform {
  backend "gcs" {
    bucket = "my-bucket-aqueous"
    prefix = "terraform/state/dev/gke"
  }
}

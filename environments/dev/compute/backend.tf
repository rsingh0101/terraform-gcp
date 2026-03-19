terraform {
  backend "gcs" {
    bucket = "replace-with-your-terraform-state-bucket"
    prefix = "terraform/state/dev/compute"
  }
}

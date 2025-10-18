resource "google_compute_disk" "additional" {
  for_each = { for d in var.additional_disks : d.name => d }

  name  = each.value.name
  type  = each.value.type
  zone  = var.zone
  size  = each.value.size_gb
}

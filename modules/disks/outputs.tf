output "disk_ids" {
  value = {
    for name, disk in google_compute_disk.additional : name => disk.id
  }
}

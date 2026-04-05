output "disk_ids" {
  value = {
    for name, disk in google_compute_disk.disks : name => disk.id
  }
}

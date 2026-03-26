resource "google_compute_firewall" "rules" {
  for_each = { for rule in var.rules : rule.name => rule }

  project = var.project_id
  name    = each.value.name
  network = var.network

  description = try(each.value.description, null)
  direction   = try(each.value.direction, "INGRESS")
  priority    = try(each.value.priority, 1000)

  source_ranges      = try(each.value.source_ranges, [])
  destination_ranges = try(each.value.destination_ranges, [])
  target_tags        = try(each.value.target_tags, [])

  dynamic "allow" {
    for_each = try(each.value.allow, [])
    content {
      protocol = allow.value.protocol
      ports    = try(allow.value.ports, null)
    }
  }

  dynamic "deny" {
    for_each = try(each.value.deny, [])
    content {
      protocol = deny.value.protocol
      ports    = try(deny.value.ports, null)
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}
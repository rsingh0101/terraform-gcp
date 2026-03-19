output "instance_name" {
  description = "The name of the database instance."
  value       = google_sql_database_instance.master.name
}

output "private_ip_address" {
  description = "The private IP address of the SQL instance."
  value       = google_sql_database_instance.master.private_ip_address
}

output "connection_name" {
  description = "The connection name of the master instance to be used in connection strings."
  value       = google_sql_database_instance.master.connection_name
}

variable "project_id" {
  description = "The project ID."
  type        = string
}

variable "name" {
  description = "The name of the Cloud SQL instance."
  type        = string
}

variable "region" {
  description = "The region of the Cloud SQL resources."
  type        = string
  default     = "us-central1"
}

variable "database_version" {
  description = "The database version to use."
  type        = string
  default     = "POSTGRES_14"
}

variable "tier" {
  description = "The machine tier (e.g., db-f1-micro or db-custom-2-7680)."
  type        = string
  default     = "db-custom-2-7680"
}

variable "availability_type" {
  description = "The availability type of the Cloud SQL instance, high availability (REGIONAL) or single zone (ZONAL)."
  type        = string
  default     = "REGIONAL"
}

variable "disk_size" {
  description = "The minimum disk size."
  type        = number
  default     = 100
}

variable "disk_type" {
  description = "The type of data disk: PD_SSD or PD_HDD."
  type        = string
  default     = "PD_SSD"
}

variable "vpc_network_id" {
  description = "The VPC network self link to connect to (required for private IP)."
  type        = string
}

variable "backup_start_time" {
  description = "HH:MM format (e.g. 04:00) for daily backup start."
  type        = string
  default     = "03:00"
}

variable "maintenance_day" {
  description = "Day of week (1-7), starting on Monday."
  type        = number
  default     = 7 # Sunday
}

variable "maintenance_hour" {
  description = "Hour of day (0-23)."
  type        = number
  default     = 2
}

variable "labels" {
  description = "Key/value labels."
  type        = map(string)
  default     = {}
}

variable "db_name" {
  description = "The name of the default database to create."
  type        = string
  default     = "default_db"
}

variable "user_names" {
  description = "List of database user names to create."
  type        = list(string)
  default     = []
}

variable "user_password" {
  description = "Password for the database users (Note: use Secret Manager in root modules to supply this)."
  type        = string
  sensitive   = true
}

variable "deletion_protection" {
  description = "Used to block Terraform from deleting a SQL Instance."
  type        = bool
  default     = true
}

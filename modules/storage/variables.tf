variable "project_id" {
  description = "The ID of the project in which to provision resources."
  type        = string
}

variable "name" {
  description = "The name of the bucket."
  type        = string
}

variable "location" {
  description = "The GCS location."
  type        = string
}

variable "storage_class" {
  description = "The Storage Class of the new bucket."
  type        = string
  default     = "STANDARD"
}

variable "force_destroy" {
  description = "When deleting a bucket, this boolean option will delete all contained objects."
  type        = bool
  default     = false
}

variable "versioning" {
  description = "While set to true, versioning is fully enabled for this bucket."
  type        = bool
  default     = true
}

variable "kms_key_name" {
  description = "A Cloud KMS key that will be used to encrypt objects inserted into this bucket."
  type        = string
  default     = null
}

variable "lifecycle_rules" {
  description = "The bucket's Lifecycle Rules configuration."
  type = list(object({
    action    = any
    condition = any
  }))
  default = []
}

variable "labels" {
  description = "A set of key/value label pairs to assign to the bucket."
  type        = map(string)
  default     = {}
}

variable "iam_bindings" {
  description = "A map of IAM roles to a list of members. Eg: { \"roles/storage.objectAdmin\" : [\"user:admin@example.com\"] }"
  type        = map(list(string))
  default     = {}
}

variable "kms_key_name" {
  type        = string
  description = "Resource name of the Cloud KMS key used to encrypt topics and subscriptions"
  sensitive   = true

  validation {
    condition     = length(trimspace(var.kms_key_name)) > 0
    error_message = "var.kms_key_name must be a non-empty string"
  }
}

variable "message_retention_duration" {
  type        = string
  description = "Message retention duration for topics and subscriptions, e.g. 604800s for 7 days"
  default     = "604800s"

  validation {
    condition     = can(regex("^[0-9]+s$", var.message_retention_duration))
    error_message = "var.message_retention_duration must be a duration string like 604800s"
  }
}

variable "push_endpoint" {
  type        = string
  description = "HTTPS endpoint (Cloud Run URL) that the push subscription delivers messages to"

  validation {
    condition     = can(regex("^https://", var.push_endpoint))
    error_message = "var.push_endpoint must be an https:// URL"
  }
}

variable "push_service_account_email" {
  type        = string
  description = "Service account email used by the push subscription's OIDC token; must hold roles/run.invoker on the target Cloud Run service"

  validation {
    condition     = can(regex("^[^@]+@[^@]+\\.iam\\.gserviceaccount\\.com$", var.push_service_account_email))
    error_message = "var.push_service_account_email must be a valid service account email"
  }
}

variable "cloud_run_service_name" {
  type        = string
  description = "Name of the Cloud Run v2 service the push subscription invokes"

  validation {
    condition     = length(trimspace(var.cloud_run_service_name)) > 0
    error_message = "var.cloud_run_service_name must be a non-empty string"
  }
}

variable "publisher_member" {
  type        = string
  description = "IAM member granted roles/pubsub.publisher on the main topic, e.g. serviceAccount:writer@project.iam.gserviceaccount.com"

  validation {
    condition     = !contains(["allUsers", "allAuthenticatedUsers"], var.publisher_member)
    error_message = "var.publisher_member must not be allUsers or allAuthenticatedUsers"
  }
}

variable "subscriber_member" {
  type        = string
  description = "IAM member granted roles/pubsub.subscriber on the main subscription"

  validation {
    condition     = !contains(["allUsers", "allAuthenticatedUsers"], var.subscriber_member)
    error_message = "var.subscriber_member must not be allUsers or allAuthenticatedUsers"
  }
}
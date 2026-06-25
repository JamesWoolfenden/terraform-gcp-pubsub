resource "google_pubsub_topic" "main" {
  name                       = "main"
  kms_key_name               = var.kms_key_name
  message_retention_duration = var.message_retention_duration
}
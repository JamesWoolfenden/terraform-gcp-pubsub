resource "google_pubsub_topic" "dead_letter" {
  name                       = "dead-letter"
  kms_key_name               = var.kms_key_name
  message_retention_duration = var.message_retention_duration
}
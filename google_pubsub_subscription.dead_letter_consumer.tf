resource "google_pubsub_subscription" "dead_letter_consumer" {
  name                       = "dead-letter-consumer"
  topic                      = google_pubsub_topic.dead_letter.id
  kms_key_name               = var.kms_key_name
  ack_deadline_seconds       = 600
  message_retention_duration = var.message_retention_duration
}
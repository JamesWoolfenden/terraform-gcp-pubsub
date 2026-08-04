resource "google_pubsub_subscription" "dead_letter_consumer" {
  name                       = "dead-letter-consumer"
  topic                      = google_pubsub_topic.dead_letter.id
  ack_deadline_seconds       = 600
  message_retention_duration = var.message_retention_duration

  expiration_policy {
    ttl = ""
  }
}
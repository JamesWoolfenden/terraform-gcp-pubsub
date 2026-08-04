resource "google_pubsub_subscription" "main" {
  name                       = "main"
  topic                      = google_pubsub_topic.main.id
  message_retention_duration = var.message_retention_duration

  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.dead_letter.id
    max_delivery_attempts = 5
  }

  depends_on = [
    google_pubsub_topic_iam_member.dlq_publisher
  ]
}
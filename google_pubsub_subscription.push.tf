resource "google_pubsub_subscription" "push" {
  name                       = "push"
  topic                      = google_pubsub_topic.main.id
  message_retention_duration = var.message_retention_duration
  ack_deadline_seconds       = 60

  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.dead_letter.id
    max_delivery_attempts = 5
  }

  expiration_policy {
    ttl = ""
  }

  push_config {
    push_endpoint = var.push_endpoint

    oidc_token {
      service_account_email = var.push_service_account_email
    }
  }

  depends_on = [
    google_cloud_run_v2_service_iam_member.pubsub_push_invoke
  ]
}
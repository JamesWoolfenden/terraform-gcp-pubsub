resource "google_pubsub_subscription" "push" {
  name                       = "push"
  topic                      = google_pubsub_topic.main.id
  kms_key_name               = var.kms_key_name
  message_retention_duration = var.message_retention_duration

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
resource "google_pubsub_topic" "main" {
  name                       = "main"
  kms_key_name               = var.kms_key_name
  message_retention_duration = var.message_retention_duration

  depends_on = [
    google_kms_crypto_key_iam_member.pubsub_service_agent
  ]
}
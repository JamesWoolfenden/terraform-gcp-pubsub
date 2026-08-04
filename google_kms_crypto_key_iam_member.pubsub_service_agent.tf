resource "google_kms_crypto_key_iam_member" "pubsub_service_agent" {
  crypto_key_id = var.kms_key_name
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:${google_project_service_identity.pubsub.email}"
}

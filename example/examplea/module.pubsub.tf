resource "google_kms_key_ring" "pubsub" {
  name     = "pubsub-keyring"
  location = "europe-west2"
}

resource "google_kms_crypto_key" "pubsub" {
  name     = "pubsub-key"
  key_ring = google_kms_key_ring.pubsub.id

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_service_account" "pubsub_push" {
  account_id   = "pubsub-push"
  display_name = "Pub/Sub push subscription invoker"
}

resource "google_cloud_run_v2_service" "consumer" {
  name     = "pubsub-consumer"
  location = "europe-west2"
  ingress  = "INGRESS_TRAFFIC_INTERNAL_ONLY"

  template {
    containers {
      image = "gcr.io/cloudrun/hello"
    }
  }
}

# holden:ignore:HLD_TF_026 — examples intentionally use ../../ to reference the local module root
module "pubsub" {
  source                     = "../../"
  kms_key_name               = google_kms_crypto_key.pubsub.id
  message_retention_duration = "604800s"
  push_endpoint              = google_cloud_run_v2_service.consumer.uri
  push_service_account_email = google_service_account.pubsub_push.email
  cloud_run_service_name     = google_cloud_run_v2_service.consumer.name
  publisher_member           = "serviceAccount:${google_service_account.pubsub_push.email}"
  subscriber_member          = "serviceAccount:${google_service_account.pubsub_push.email}"
}
resource "google_kms_key_ring" "pubsub" {
  name     = "pubsub-keyring"
  location = "europe-west2"
}

# holden:ignore:HLD_GCP_017: Tthis is a sample example, so we don't need to worry about the KMS key being destroyed. In production, you should set prevent_destroy = true.
resource "google_kms_crypto_key" "pubsub" {
  name            = "pubsub-key"
  key_ring        = google_kms_key_ring.pubsub.id
  rotation_period = "7776000s" # 90 days

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_kms_crypto_key_iam_member" "cloud_run_cmek" {
  crypto_key_id = google_kms_crypto_key.pubsub.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:service-${data.google_project.current.number}@serverless-robot-prod.iam.gserviceaccount.com"
}

resource "google_service_account" "pubsub_push" {
  account_id   = "pubsub-push"
  display_name = "Pub/Sub push subscription invoker"
}

# holden:ignore:HLD_GCP_200 — image is Google's public Cloud Run quickstart
# demo, used here only as a placeholder container. In production, pin to a
# version tag or @sha256 digest.
resource "google_cloud_run_v2_service" "consumer" {
  name     = "pubsub-consumer"
  location = "europe-west2"
  ingress  = "INGRESS_TRAFFIC_INTERNAL_ONLY"

  binary_authorization {
    use_default = true
  }

  template {
    service_account = google_service_account.pubsub_push.email
    encryption_key  = google_kms_crypto_key.pubsub.id
    timeout         = "3600s"

    containers {
      image = "gcr.io/cloudrun/hello"

      resources {
        limits = {
          cpu    = "1"
          memory = "512Mi"
        }
      }
    }

    vpc_access {
      connector = "projects/${data.google_project.current.project_id}/locations/europe-west2/connectors/default"
      egress    = "PRIVATE_RANGES_ONLY"
    }
  }

  depends_on = [
    google_kms_crypto_key_iam_member.cloud_run_cmek
  ]
}

data "google_project" "current" {
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
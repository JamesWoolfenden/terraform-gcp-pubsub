resource "google_pubsub_subscription_iam_member" "subscriber" {
  subscription = google_pubsub_subscription.main.id
  role         = "roles/pubsub.subscriber"
  member       = var.subscriber_member
}
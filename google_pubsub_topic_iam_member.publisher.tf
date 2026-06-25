resource "google_pubsub_topic_iam_member" "publisher" {
  topic  = google_pubsub_topic.main.id
  role   = "roles/pubsub.publisher"
  member = var.publisher_member
}
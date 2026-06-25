output "topic_id" {
  value       = google_pubsub_topic.main.id
  description = "ID of the main Pub/Sub topic"
}

output "dead_letter_topic_id" {
  value       = google_pubsub_topic.dead_letter.id
  description = "ID of the dead-letter topic"
}

output "subscription_id" {
  value       = google_pubsub_subscription.main.id
  description = "ID of the main pull subscription"
}

output "push_subscription_id" {
  value       = google_pubsub_subscription.push.id
  description = "ID of the push subscription"
}
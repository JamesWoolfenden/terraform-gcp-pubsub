resource "google_cloud_run_v2_service_iam_member" "pubsub_push_invoke" {
  name     = var.cloud_run_service_name
  location = "europe-west2"
  role     = "roles/run.invoker"
  member   = "serviceAccount:${var.push_service_account_email}"
}
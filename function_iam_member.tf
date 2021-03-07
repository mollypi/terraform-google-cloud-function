//# IAM entry for all users to invoke the function
resource "google_cloudfunctions_function_iam_member" "invoker" {
  for_each       = var.trigger_type == local.TRIGGER_TYPE_HTTP ? toset(var.invokers) : toset([])
  project        = google_cloudfunctions_function.http_function[0].project
  region         = google_cloudfunctions_function.http_function[0].region
  cloud_function = google_cloudfunctions_function.http_function[0].name

  role   = "roles/cloudfunctions.invoker"
  member = each.value
}
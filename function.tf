resource "google_cloudfunctions_function" "event_function" {
  count = var.trigger_type != local.TRIGGER_TYPE_HTTP ? 1 : 0

  name        = "${var.teamid}-${var.prjid}"
  description = "${var.teamid}-${var.prjid} processes events"


  runtime               = var.runtime
  region                = var.gcp_region
  project               = var.gcp_project
  available_memory_mb   = var.available_memory_mb
  timeout               = var.timeout
  source_archive_bucket = var.function_archive_bucket_name
  source_archive_object = google_storage_bucket_object.archive.name
  max_instances         = var.max_instances

  event_trigger {
    event_type = var.trigger_type == local.TRIGGER_TYPE_SCHEDULER ? "google.pubsub.topic.publish" : var.trigger_event_type
    resource   = var.trigger_type == local.TRIGGER_TYPE_SCHEDULER ? google_pubsub_topic.scheduler[0].id : var.trigger_event_resource
  }

  entry_point                   = var.entry_point
  environment_variables         = var.environment_vars
  ingress_settings              = var.ingress_settings
  service_account_email         = var.service_account_email == null ? "" : var.service_account_email
  vpc_connector_egress_settings = var.vpc_connector_egress_settings
  vpc_connector                 = var.vpc_connector
  labels                        = merge(local.shared_labels)
}

resource "google_cloudfunctions_function" "http_function" {
  count = var.trigger_type == local.TRIGGER_TYPE_HTTP ? 1 : 0

  name        = "${var.teamid}-${var.prjid}"
  description = "${var.teamid}-${var.prjid} function"

  runtime                       = var.runtime
  project                       = var.gcp_project
  region                        = var.gcp_region
  available_memory_mb           = var.available_memory_mb
  timeout                       = var.timeout
  source_archive_bucket         = var.function_archive_bucket_name
  source_archive_object         = google_storage_bucket_object.archive.name
  trigger_http                  = true
  entry_point                   = var.entry_point
  environment_variables         = var.environment_vars
  ingress_settings              = var.ingress_settings
  service_account_email         = var.service_account_email == null ? "" : var.service_account_email

  vpc_connector_egress_settings = var.vpc_connector_egress_settings
  vpc_connector                 = var.vpc_connector
  labels                        = merge(local.shared_labels)
}

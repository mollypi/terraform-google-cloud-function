resource "google_pubsub_topic" "scheduler" {
  count   = var.trigger_type == local.TRIGGER_TYPE_SCHEDULER ? 1 : 0
  name    = "${var.teamid}-${var.prjid}"
  labels  = merge(local.shared_labels)
  project = var.gcp_project
}

resource "google_cloud_scheduler_job" "scheduler" {
  count       = var.trigger_type == local.TRIGGER_TYPE_SCHEDULER ? 1 : 0
  name        = "${var.teamid}-${var.prjid}"
  description = "${var.teamid}-${var.prjid} triggers function"
  schedule    = var.schedule
  time_zone   = var.schedule_time_zone
  region      = var.gcp_region

  pubsub_target {
    attributes = {}
    topic_name = google_pubsub_topic.scheduler[0].id
    data       = base64encode(var.schedule_payload)
  }

  retry_config {
    retry_count          = var.schedule_retry_config.retry_count
    max_retry_duration   = var.schedule_retry_config.max_retry_duration
    min_backoff_duration = var.schedule_retry_config.min_backoff_duration
    max_backoff_duration = var.schedule_retry_config.max_backoff_duration
    max_doublings        = var.schedule_retry_config.max_doublings
  }
}
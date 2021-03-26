locals {

  shared_labels = map(
    "name", "${var.teamid}-${var.prjid}",
    "team", var.teamid,
    "project", var.prjid
  )

  TRIGGER_TYPE_HTTP      = "http"
  TRIGGER_TYPE_TOPIC     = "topic"
  TRIGGER_TYPE_SCHEDULER = "scheduler"
  TRIGGER_TYPE_BUCKET    = "bucket"
}
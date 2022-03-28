locals {
  alerts_enabled = length(var.alert_slack_token) > 0 && var.sls_project_env == "prod"
}

locals {
  slack_message = <<-EOT
    :warning: Function test
    EOT
}

resource "google_monitoring_notification_channel" "slack" {
  count = local.alerts_enabled ? 1 : 0

  display_name = "${var.teamid}-${var.prjid} Slack Notification"
  type         = "slack"
  description  = "A slack notification channel"
  enabled      = true
  labels = {
    "channel_name" = var.alert_channel
  }

  sensitive_labels {
    auth_token = var.alert_slack_token
  }
}

resource "google_logging_metric" "metric" {
  count = local.alerts_enabled ? 1 : 0

  name        = "${var.teamid}-${var.prjid}-metric"
  description = "${var.teamid}-${var.prjid} metric"

  filter = <<-EOT
    resource.type="cloud_function"
    resource.labels.function_name="${var.teamid}-${var.prjid}"
    severity="DEBUG"
    "finished with status: 'crash'"
    OR
    "finished with status: 'error'"
    OR
    "finished with status: 'timeout'"
    OR
    "finished with status: 'connection error'"
    EOT

  label_extractors = {
    "function_name" = "EXTRACT(resource.labels.function_name)"
  }
  metric_descriptor {
    display_name = "${var.teamid}-${var.prjid}-metric-descriptor"
    metric_kind  = "DELTA"
    value_type   = "INT64"
    labels {
      key        = "function_name"
      value_type = "STRING"
    }
  }
}

resource "google_monitoring_alert_policy" "alert_policy" {
  count = local.alerts_enabled ? 1 : 0

  display_name = "${var.teamid}-${var.prjid}-alert-policy"
  combiner     = "OR"
  notification_channels = [
    google_monitoring_notification_channel.slack[0].id
  ]
  conditions {
    display_name = "${var.teamid}-${var.prjid} alert policy condition"
    condition_threshold {
      filter     = "metric.type=\"logging.googleapis.com/user/${google_logging_metric.metric[0].id}\" resource.type=\"cloud_function\""
      duration   = "0s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period   = var.alert_alignment_period
        per_series_aligner = "ALIGN_DELTA"
      }
      trigger {
        count   = 1
        percent = 0
      }
    }
  }
  documentation {
    content   = local.slack_message
    mime_type = "text/markdown"
  }
}

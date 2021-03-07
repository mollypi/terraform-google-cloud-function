output "function_http_url" {
  description = "function http trigger url"
  value       = join(" ", google_cloudfunctions_function.http_function.*.https_trigger_url)
}

output "scheduler_topic_id" {
  value = join(" ", google_pubsub_topic.scheduler.*.id)
}

output "function_name" {
  description = "function name"
  value       = join(" ", google_cloudfunctions_function.event_function.*.name)
}

output "function_service_account_email" {
  description = "Service account email"
  value       = join(" ", google_cloudfunctions_function.event_function.*.service_account_email)
}

output "function_runtime" {
  description = "function runtime"
  value       = join(" ", google_cloudfunctions_function.event_function.*.runtime)
}

output "function_region" {
  description = "function region"
  value       = join(" ", google_cloudfunctions_function.event_function.*.region)
}

output "function_memory" {
  description = "function memory"
  value       = join(" ", google_cloudfunctions_function.event_function.*.available_memory_mb)
}

output "function_project" {
  description = "function project"
  value       = join(" ", google_cloudfunctions_function.event_function.*.project)
}

output "function_id" {
  description = "function id"
  value       = join(" ", google_cloudfunctions_function.event_function.*.id)
}

output "function_source_archive_bucket" {
  description = "function source archive bucket"
  value       = join(" ", google_cloudfunctions_function.event_function.*.source_archive_bucket)

}

output "function_source_archive_object" {
  description = "function source archive object"
  value       = join(" ", google_cloudfunctions_function.event_function.*.source_archive_object)

}

output "function_vpc_egress_settings" {
  description = "function vpc egress settings"
  value       = join(" ", google_cloudfunctions_function.event_function.*.vpc_connector_egress_settings)
}
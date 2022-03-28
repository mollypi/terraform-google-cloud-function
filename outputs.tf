output "function_http_url" {
  description = "Function http trigger url"
  value       = join(" ", google_cloudfunctions_function.http_function.*.https_trigger_url)
}

output "function_name" {
  description = "Function name"
  value       = join(" ", google_cloudfunctions_function.event_function.*.name)
}

output "function_service_account_email" {
  description = "Service account email"
  value       = join(" ", google_cloudfunctions_function.event_function.*.service_account_email)
}

output "function_runtime" {
  description = "Function runtime"
  value       = join(" ", google_cloudfunctions_function.event_function.*.runtime)
}

output "function_region" {
  description = "Function region"
  value       = join(" ", google_cloudfunctions_function.event_function.*.region)
}

output "function_memory" {
  description = "Function memory"
  value       = join(" ", google_cloudfunctions_function.event_function.*.available_memory_mb)
}

output "function_project" {
  description = "Function project"
  value       = join(" ", google_cloudfunctions_function.event_function.*.project)
}

output "function_id" {
  description = "Function id"
  value       = join(" ", google_cloudfunctions_function.event_function.*.id)
}

output "function_source_archive_bucket" {
  description = "Function source archive bucket"
  value       = join(" ", google_cloudfunctions_function.event_function.*.source_archive_bucket)

}

output "function_source_archive_object" {
  description = "Function source archive object"
  value       = join(" ", google_cloudfunctions_function.event_function.*.source_archive_object)

}

output "function_vpc_egress_settings" {
  description = "Function vpc egress settings"
  value       = join(" ", google_cloudfunctions_function.event_function.*.vpc_connector_egress_settings)
}

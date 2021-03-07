variable "teamid" {
  description = "(Required) Name of the team/group e.g. devops, dataengineering. Should not be changed after running 'tf apply'"
}

variable "prjid" {
  description = "(Required) Name of the project/stack e.g: mystack, nifieks, demoaci. Should not be changed after running 'tf apply'"
}

variable "gcp_project" {
  description = "Name of the GCP project"
}

variable "gcp_region" {
  default = "us-central1"
}

variable "source_file" {}

variable "output_file_path" {}

variable "archive_type" {
  default = "zip"
}

resource "random_string" "naming" {
  special = false
  upper   = false
  length  = 3
}

locals {
  prefix = random_string.naming.result
}

variable "runtime" {
  default     = "python37"
  description = "(Required) The runtime in which the function is going to run. Eg. python37, go113"
}

variable "available_memory_mb" {
  default     = 128
  description = "Memory available in MB. Default value is 256MB. Allowed values are: 128MB, 256MB, 512MB, 1024MB, 2048MB and 4096MB."
}

variable "gcp_function_role" {
  default = "roles/cloudfunctions.invoker"
}

variable "entry_point" {
  type        = string
  description = "The name of a method in the function source which will be invoked when the function is executed."
}

variable "environment_vars" {
  type        = map(string)
  default     = {}
  description = "A set of key/value environment variable pairs to assign to the function."
}

variable "gcp_zone" {
  default = "us-central1a"
}

variable "timeout" {
  default = 60
}

variable "function_archive_bucket_name" {
  description = "The GCS bucket containing the zip archive which contains the function."
  default     = null
}

variable "ingress_settings" {
  type        = string
  default     = "ALLOW_ALL"
  description = "The ingress settings for the function. Allowed values are ALLOW_ALL, ALLOW_INTERNAL_AND_GCLB and ALLOW_INTERNAL_ONLY. Changes to this field will recreate the cloud function."
}

variable "service_account_email" {
  description = "The self-provided service account to run the function with."
  default     = null
}

variable "max_instances" {
  type        = number
  default     = 0
  description = "The maximum number of parallel executions of the function."
}

variable "vpc_connector_egress_settings" {
  type        = string
  default     = null
  description = "The egress settings for the connector, controlling what traffic is diverted through it. Allowed values are ALL_TRAFFIC and PRIVATE_RANGES_ONLY. If unset, this field preserves the previously set value."
}

variable "vpc_connector" {
  type        = string
  default     = null
  description = "The VPC Network Connector that this cloud function can connect to. It should be set up as fully-qualified URI. The format of this field is projects/*/locations/*/connectors/*."
}

variable "event_trigger_failure_policy_retry" {
  type        = bool
  default     = false
  description = "A toggle to determine if the function should be retried on failure."
}

variable "trigger_type" {
  type        = string
  description = "Function trigger type that must be provided"

  validation {
    condition     = can(regex("^(http|topic|scheduler|bucket)$", var.trigger_type))
    error_message = "Possible values are: http, topic, scheduler or bucket."
  }
}

variable "schedule" {
  type        = string
  description = "Describes the schedule on which the job will be executed"
  default     = "*/30 * * * *"
}

variable "schedule_time_zone" {
  type        = string
  description = "Specifies the time zone to be used in interpreting schedule. The value of this field must be a time zone name from the tz database"
  default     = "America/Los_Angeles"
}

variable "schedule_retry_config" {
  type = object({
    retry_count          = number,
    max_retry_duration   = string,
    min_backoff_duration = string,
    max_backoff_duration = string,
    max_doublings        = number,
  })
  description = "By default, if a job does not complete successfully, meaning that an acknowledgement is not received from the handler, then it will be retried with exponential backoff"
  default = {
    retry_count          = 0,
    max_retry_duration   = "0s",
    min_backoff_duration = "5s",
    max_backoff_duration = "3600s",
    max_doublings        = 5
  }
}

variable "schedule_payload" {
  type        = string
  description = "Payload for Cloud Scheduler"
  default     = "{}"
}

variable "invokers" {
  type        = list(string)
  description = "List of function invokers (i.e. allUsers if you want to Allow unauthenticated)"
  default     = []
}

variable "vpc_access_connector" {
  type        = string
  description = "Enable access to shared VPC 'projects/<host-project>/locations/<region>/connectors/<connector>'"
  default     = null
}

variable "trigger_event_type" {
  type        = string
  description = "The type of event to observe. Only for topic and bucket triggered functions"
  default     = ""
}

variable "trigger_event_resource" {
  type        = string
  description = "The name or partial URI of the resource from which to observe events. Only for topic and bucket triggered functions"
  default     = ""
}

variable "sls_project_env" {
  type        = string
  description = "Project's SLS environment."
}
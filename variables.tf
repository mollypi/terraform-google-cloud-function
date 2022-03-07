variable "teamid" {
  description = "Name of the team/group e.g. devops, dataengineering. Should not be changed after running 'tf apply'"
  type        = string
}

variable "prjid" {
  description = "Name of the project/stack e.g: mystack, nifieks, demoaci. Should not be changed after running 'tf apply'"
  type        = string
}

variable "source_file" {
  description = "Source file"
  type        = string
}

variable "output_file_path" {
  description = "Zip file location"
  type        = string
}

variable "archive_type" {
  description = "Archive type"
  default     = "zip"
  type        = string
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
  description = "The runtime in which the function is going to run. Eg. python37, go113"
  type        = string
}

variable "available_memory_mb" {
  default     = 128
  description = "Memory available in MB. Default value is 256MB. Allowed values are: 128MB, 256MB, 512MB, 1024MB, 2048MB and 4096MB"
  type        = string
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

variable "timeout" {
  description = "Timeout"
  default     = 60
  type        = number
}

variable "function_archive_bucket_name" {
  description = "The GCS bucket containing the zip archive which contains the function."
  default     = null
  type        = string
}

variable "ingress_settings" {
  type        = string
  default     = "ALLOW_ALL"
  description = "The ingress settings for the function. Allowed values are ALLOW_ALL, ALLOW_INTERNAL_AND_GCLB and ALLOW_INTERNAL_ONLY. Changes to this field will recreate the cloud function."
}

variable "service_account_email" {
  description = "The self-provided service account to run the function with."
  default     = null
  type        = string
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

variable "trigger_type" {
  type        = string
  description = "Function trigger type that must be provided"

  validation {
    condition     = can(regex("^(http|topic|scheduler|bucket)$", var.trigger_type))
    error_message = "Possible values are: http, topic, scheduler or bucket."
  }
}


variable "invokers" {
  type        = list(string)
  description = "List of function invokers (i.e. allUsers if you want to Allow unauthenticated)"
  default     = []
}

variable "trigger_event_resource" {
  type        = string
  description = "The name or partial URI of the resource from which to observe events. Only for topic and bucket triggered functions"
  default     = ""
}

variable "trigger_event_type" {
  type        = string
  description = "The type of event to observe. Only for topic and bucket triggered functions"
  default     = ""
}

variable "sls_project_env" {
  type        = string
  description = "Project's SLS environment."
  default     = "dev"
}

# alerts
variable "alert_slack_token" {
  description = "A Slack token that is used for alerting."
  default     = "xapp-1-1234567-1234567-1234567"
  type        = string
}

variable "alert_channel" {
  description = "A Slack channel to send alerts to."
  default     = "#gcp-function"
  type        = string
}

variable "alert_alignment_period" {
  description = "Alignment period for alerts."
  default     = "60s"
  type        = string
}

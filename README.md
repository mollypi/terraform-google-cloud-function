<p align="center">
    <a href="https://github.com/tomarv2/terraform-google-cloudfunction/actions/workflows/pre-commit.yml" alt="Pre Commit">
        <img src="https://github.com/tomarv2/terraform-google-cloudfunction/actions/workflows/pre-commit.yml/badge.svg?branch=main" /></a>
    <a href="https://www.apache.org/licenses/LICENSE-2.0" alt="license">
        <img src="https://img.shields.io/github/license/tomarv2/terraform-google-cloudfunction" /></a>
    <a href="https://github.com/tomarv2/terraform-google-cloudfunction/tags" alt="GitHub tag">
        <img src="https://img.shields.io/github/v/tag/tomarv2/terraform-google-cloudfunction" /></a>
    <a href="https://github.com/tomarv2/terraform-google-cloudfunction/pulse" alt="Activity">
        <img src="https://img.shields.io/github/commit-activity/m/tomarv2/terraform-google-cloudfunction" /></a>
    <a href="https://stackoverflow.com/users/6679867/tomarv2" alt="Stack Exchange reputation">
        <img src="https://img.shields.io/stackexchange/stackoverflow/r/6679867"></a>
    <a href="https://twitter.com/intent/follow?screen_name=varuntomar2019" alt="follow on Twitter">
        <img src="https://img.shields.io/twitter/follow/varuntomar2019?style=social&logo=twitter"></a>
</p>

## Terraform module for Google Cloud Function (HTTP and Event triggers)

#### Versions

- Module tested for Terraform 1.0.1.
- Google provider version [4.12.0](https://registry.terraform.io/providers/hashicorp/google/latest)
- `main` branch: Provider versions not pinned to keep up with Terraform releases
- `tags` releases: Tags are pinned with versions (use <a href="https://github.com/tomarv2/terraform-google-cloudfunction/tags" alt="GitHub tag">
        <img src="https://img.shields.io/github/v/tag/tomarv2/terraform-google-cloudfunction" /></a> in your releases)

#### Usage

##### Option 1:

```
terrafrom init
terraform plan -var='teamid=tryme' -var='prjid=project1'
terraform apply -var='teamid=tryme' -var='prjid=project1'
terraform destroy -var='teamid=tryme' -var='prjid=project1'
```
**Note:** With this option please take care of remote state storage

##### Option 2:

###### Recommended method (stores remote state in remote backend(S3,  Azure storage, or Google bucket) using `prjid` and `teamid` to create directory structure):

- Create python 3.8+ virtual environment
```
python3 -m venv <venv name>
```

- Install package:
```
pip install tfremote --upgrade
```

- Set below environment variables:
```
export TF_GCLOUD_BUCKET=<remote state bucket name>
export TF_GCLOUD_PREFIX=<remote state bucket prefix>
export TF_GCLOUD_CREDENTIALS=<gcp credentials.json>
```

- Updated `examples` directory with required values.

- Run and verify the output before deploying:
```
tf -c=gcloud plan -var='teamid=foo' -var='prjid=bar'
```

- Run below to deploy:
```
tf -c=gcloud apply -var='teamid=foo' -var='prjid=bar'
```

- Run below to destroy:
```
tf -c=gcloud destroy -var='teamid=foo' -var='prjid=bar'
```

**Note:** Read more on [tfremote](https://github.com/tomarv2/tfremote)
##### Function with existing storage bucket
```
terraform {
  required_version = ">= 1.0.1"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.12.0"
    }
  }
}

provider "google" {
  region  = var.region
  project = var.project
}


module "cloudfunction" {
  source = "../../"

  environment_vars = {
    "HELLO" = "WORLD"
  }
  output_file_path             = "/tmp/test.zip"
  source_file                  = "main.py"
  function_archive_bucket_name = var.bucket_name
  ingress_settings             = "ALLOW_ALL"
  entry_point                  = "function_handler"
  #----------------------------------------
  # NOTE:
  # trigger_event_type & trigger_event_resource is only required
  # when trigger_type is bucket and topic
  trigger_type           = "bucket"
  trigger_event_type     = "google.storage.object.finalize"
  trigger_event_resource = var.bucket_name
  sls_project_env        = "dev"
  invokers               = ["allUsers"]
  service_account_email  = "demo@demo-1000.iam.gserviceaccount.com"
  #----------------------------------------
  # Note: Do not change teamid and prjid once set.
  teamid = var.teamid
  prjid  = var.prjid
}
```

Please refer to examples directory [link](examples) for references.


### Permissions

**Service account with the following roles is required:**

- [`roles/cloudfunctions.developer`](https://cloud.google.com/iam/docs/understanding-roles#cloud-functions-roles)
- [`roles/storage.admin`](https://cloud.google.com/iam/docs/understanding-roles#cloud-storage-roles)

### Required APIs

**Following APIs must be enabled on the project:**

- `cloudfunctions.googleapis.com`
- `storage-component.googleapis.com`

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.1 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | 2.2.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 4.12.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | 2.2.0 |
| <a name="provider_google"></a> [google](#provider\_google) | ~> 4.12.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.1.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_cloudfunctions_function.event_function](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudfunctions_function) | resource |
| [google_cloudfunctions_function.http_function](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudfunctions_function) | resource |
| [google_cloudfunctions_function_iam_member.invoker](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudfunctions_function_iam_member) | resource |
| [google_logging_metric.metric](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/logging_metric) | resource |
| [google_monitoring_alert_policy.alert_policy](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/monitoring_alert_policy) | resource |
| [google_monitoring_notification_channel.slack](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/monitoring_notification_channel) | resource |
| [google_storage_bucket_object.archive](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_object) | resource |
| [random_string.naming](https://registry.terraform.io/providers/hashicorp/random/3.1.0/docs/resources/string) | resource |
| [archive_file.zip](https://registry.terraform.io/providers/hashicorp/archive/2.2.0/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alert_alignment_period"></a> [alert\_alignment\_period](#input\_alert\_alignment\_period) | Alignment period for alerts. | `string` | `"60s"` | no |
| <a name="input_alert_channel"></a> [alert\_channel](#input\_alert\_channel) | A Slack channel to send alerts to. | `string` | `"#gcp-function"` | no |
| <a name="input_alert_slack_token"></a> [alert\_slack\_token](#input\_alert\_slack\_token) | A Slack token that is used for alerting. | `string` | `"xapp-1-1234567-1234567-1234567"` | no |
| <a name="input_archive_type"></a> [archive\_type](#input\_archive\_type) | Archive type | `string` | `"zip"` | no |
| <a name="input_available_memory_mb"></a> [available\_memory\_mb](#input\_available\_memory\_mb) | Memory available in MB. Default value is 256MB. Allowed values are: 128MB, 256MB, 512MB, 1024MB, 2048MB and 4096MB | `string` | `128` | no |
| <a name="input_entry_point"></a> [entry\_point](#input\_entry\_point) | The name of a method in the function source which will be invoked when the function is executed. | `string` | n/a | yes |
| <a name="input_environment_vars"></a> [environment\_vars](#input\_environment\_vars) | A set of key/value environment variable pairs to assign to the function. | `map(string)` | `{}` | no |
| <a name="input_function_archive_bucket_name"></a> [function\_archive\_bucket\_name](#input\_function\_archive\_bucket\_name) | The GCS bucket containing the zip archive which contains the function. | `string` | `null` | no |
| <a name="input_ingress_settings"></a> [ingress\_settings](#input\_ingress\_settings) | The ingress settings for the function. Allowed values are ALLOW\_ALL, ALLOW\_INTERNAL\_AND\_GCLB and ALLOW\_INTERNAL\_ONLY. Changes to this field will recreate the cloud function. | `string` | `"ALLOW_ALL"` | no |
| <a name="input_invokers"></a> [invokers](#input\_invokers) | List of function invokers (i.e. allUsers if you want to Allow unauthenticated) | `list(string)` | `[]` | no |
| <a name="input_max_instances"></a> [max\_instances](#input\_max\_instances) | The maximum number of parallel executions of the function. | `number` | `0` | no |
| <a name="input_output_file_path"></a> [output\_file\_path](#input\_output\_file\_path) | Zip file location | `string` | n/a | yes |
| <a name="input_prjid"></a> [prjid](#input\_prjid) | Name of the project/stack e.g: mystack, nifieks, demoaci. Should not be changed after running 'tf apply' | `string` | n/a | yes |
| <a name="input_runtime"></a> [runtime](#input\_runtime) | The runtime in which the function is going to run. Eg. python37, go113 | `string` | `"python37"` | no |
| <a name="input_service_account_email"></a> [service\_account\_email](#input\_service\_account\_email) | The self-provided service account to run the function with. | `string` | `null` | no |
| <a name="input_sls_project_env"></a> [sls\_project\_env](#input\_sls\_project\_env) | Project's SLS environment. | `string` | `"dev"` | no |
| <a name="input_source_file"></a> [source\_file](#input\_source\_file) | Source file | `string` | n/a | yes |
| <a name="input_teamid"></a> [teamid](#input\_teamid) | Name of the team/group e.g. devops, dataengineering. Should not be changed after running 'tf apply' | `string` | n/a | yes |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | Timeout | `number` | `60` | no |
| <a name="input_trigger_event_resource"></a> [trigger\_event\_resource](#input\_trigger\_event\_resource) | The name or partial URI of the resource from which to observe events. Only for topic and bucket triggered functions | `string` | `""` | no |
| <a name="input_trigger_event_type"></a> [trigger\_event\_type](#input\_trigger\_event\_type) | The type of event to observe. Only for topic and bucket triggered functions | `string` | `""` | no |
| <a name="input_trigger_type"></a> [trigger\_type](#input\_trigger\_type) | Function trigger type that must be provided | `string` | n/a | yes |
| <a name="input_vpc_connector"></a> [vpc\_connector](#input\_vpc\_connector) | The VPC Network Connector that this cloud function can connect to. It should be set up as fully-qualified URI. The format of this field is projects/*/locations/*/connectors/*. | `string` | `null` | no |
| <a name="input_vpc_connector_egress_settings"></a> [vpc\_connector\_egress\_settings](#input\_vpc\_connector\_egress\_settings) | The egress settings for the connector, controlling what traffic is diverted through it. Allowed values are ALL\_TRAFFIC and PRIVATE\_RANGES\_ONLY. If unset, this field preserves the previously set value. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_function_http_url"></a> [function\_http\_url](#output\_function\_http\_url) | Function http trigger url |
| <a name="output_function_id"></a> [function\_id](#output\_function\_id) | Function id |
| <a name="output_function_memory"></a> [function\_memory](#output\_function\_memory) | Function memory |
| <a name="output_function_name"></a> [function\_name](#output\_function\_name) | Function name |
| <a name="output_function_project"></a> [function\_project](#output\_function\_project) | Function project |
| <a name="output_function_region"></a> [function\_region](#output\_function\_region) | Function region |
| <a name="output_function_runtime"></a> [function\_runtime](#output\_function\_runtime) | Function runtime |
| <a name="output_function_service_account_email"></a> [function\_service\_account\_email](#output\_function\_service\_account\_email) | Service account email |
| <a name="output_function_source_archive_bucket"></a> [function\_source\_archive\_bucket](#output\_function\_source\_archive\_bucket) | Function source archive bucket |
| <a name="output_function_source_archive_object"></a> [function\_source\_archive\_object](#output\_function\_source\_archive\_object) | Function source archive object |
| <a name="output_function_vpc_egress_settings"></a> [function\_vpc\_egress\_settings](#output\_function\_vpc\_egress\_settings) | Function vpc egress settings |
<!-- END_TF_DOCS -->
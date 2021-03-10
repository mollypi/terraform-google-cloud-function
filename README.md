<p align="center">
    <a href="https://github.com/tomarv2/terraform-google-cloudfunction/actions/workflows/security_scans.yml" alt="Security Scans">
        <img src="https://github.com/tomarv2/terraform-google-cloudfunction/actions/workflows/security_scans.yml/badge.svg?branch=main" /></a>
    <a href="https://www.apache.org/licenses/LICENSE-2.0" alt="license">
        <img src="https://img.shields.io/github/license/tomarv2/terraform-google-cloudfunction" /></a>
    <a href="https://github.com/tomarv2/terraform-google-cloudfunction/tags" alt="GitHub tag">
        <img src="https://img.shields.io/github/v/tag/tomarv2/terraform-google-cloudfunction" /></a>
    <a href="https://github.com/tomarv2/terraform-google-cloudfunction/pulse" alt="Activity">
        <img src="https://img.shields.io/github/commit-activity/m/tomarv2/terraform-google-cloudfunction" /></a>
    <a href="https://stackoverflow.com/users/6679867/tomarv2" alt="Stack Exchange reputation">
        <img src="https://img.shields.io/stackexchange/stackoverflow/r/6679867"></a>
    <a href="https://discord.gg/XH975bzN" alt="chat on Discord">
        <img src="https://img.shields.io/discord/813961944443912223?logo=discord"></a>
    <a href="https://twitter.com/intent/follow?screen_name=varuntomar2019" alt="follow on Twitter">
        <img src="https://img.shields.io/twitter/follow/varuntomar2019?style=social&logo=twitter"></a>
</p>

# Terraform module to create Google Cloud Function

Terraform module to create Google Cloud Function (HTTP and Event triggers)

# Versions

- Module tested for Terraform 0.14.
- Google provider version [3.58.0](https://registry.terraform.io/providers/hashicorp/google/latest)
- `main` branch: Provider versions not pinned to keep up with Terraform releases
- `tags` releases: Tags are pinned with versions (use latest     
        <a href="https://github.com/tomarv2/terraform-google-cloudfunction/tags" alt="GitHub tag">
        <img src="https://img.shields.io/github/v/tag/tomarv2/terraform-google-cloudfunction" /></a> 
  in your releases)

**NOTE:** 

- Read more on [tfremote](https://github.com/tomarv2/tfremote)

## Usage
Recommended method:

- Create python 3.6+ virtual environment 
```
python3 -m venv <venv name>
```

- Install package:
```
pip install tfremote
```

- Set below environment variables:
```
export TF_GCLOUD_BUCKET=<remote state bucket name>
export TF_GCLOUD_CREDENTIALS=<gcp credentials.json>
```  

- Updated `examples` directory to required values 

- Run and verify the output before deploying:
```
tf -cloud gcloud plan -var-file <path to .tfvars file>
```

- Run below to deploy:
```
tf -cloud gcloud apply -var-file <path to .tfvars file>
```

- Run below to destroy:
```
tf -cloud gcloud destroy -var-file <path to .tfvars file>
```

> ❗️ **Important** - Two variables are required for using `tf` package:
>
> - teamid
> - prjid
>
> These variables are required to set backend path in the remote storage.
> Variables can be defined using:
>
> - As `inline variables` e.g.: `-var='teamid=demo-team' -var='prjid=demo-project'`
> - Inside `.tfvars` file e.g.: `-var-file=<tfvars file location> `
>
> For more information refer to [Terraform documentation](https://www.terraform.io/docs/language/values/variables.html)

##### Function Only
```
module "cloudfunction" {
  source = "../../"

  gcp_project = "demo-1000"
  environment_vars = {
    "HELLO" = "WORLD"
  }
  output_file_path             = "/tmp/test.zip"
  source_file                  = "main.py"
  gcp_region                   = "us-west3"
  function_archive_bucket_name = "demo-bucket"
  ingress_settings             = "ALLOW_ALL"
  entry_point                  = "function_handler"
  #-------------------------------------------------------------------
  # NOTE:
  # trigger_event_type & trigger_event_resource is only required
  # when trigger_type is bucket and topic
  trigger_type           = "bucket"
  trigger_event_type     = "google.storage.object.finalize"
  trigger_event_resource = "demo-bucket"
  sls_project_env        = "dev"
  invokers               = ["allUsers"]
  service_account_email  = "demo@demo-1000.iam.gserviceaccount.com"
  #-------------------------------------------------------------------
  # Note: Do not change teamid and prjid once set.
  teamid = var.teamid
  prjid  = var.prjid
}
```

##### Function with Storage
```
module "cloudfunction" {
  source = "../../"

  gcp_project = "demo-1000"
  environment_vars = {
    "HELLO" = "WORLD"
  }
  output_file_path             = "/tmp/test.zip"
  source_file                  = "main.py"
  gcp_region                   = "us-west3"
  function_archive_bucket_name = module.storage_bucket.storage_bucket_name
  ingress_settings             = "ALLOW_ALL"
  entry_point                  = "function_handler"
  #-------------------------------------------------------------------
  # NOTE:
  # trigger_event_type & trigger_event_resource is only required
  # when trigger_type is bucket and topic
  trigger_type           = "http"
  trigger_event_type     = "google.storage.object.finalize"
  trigger_event_resource = "demo-bucket"
  sls_project_env        = "dev"
  invokers               = ["allUsers"]
  service_account_email  = "demo@demo-1000.iam.gserviceaccount.com"
  #-------------------------------------------------------------------
  # Note: Do not change teamid and prjid once set.
  teamid = var.teamid
  prjid  = var.prjid
}

module "storage_bucket" {
  source = "git::git@github.com:tomarv2/terraform-google-storage-bucket.git?ref=0.0.1"

  teamid      = var.teamid
  prjid       = var.prjid
  gcp_project = "demo-1000"
  gcp_region  = "us-west3"
}
```

Please refer to examples directory [link](examples) for references.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.14 |
| google | ~> 3.58 |

## Providers

| Name | Version |
|------|---------|
| archive | n/a |
| google | ~> 3.58 |
| random | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| archive\_type | n/a | `string` | `"zip"` | no |
| available\_memory\_mb | Memory available in MB. Default value is 256MB. Allowed values are: 128MB, 256MB, 512MB, 1024MB, 2048MB and 4096MB. | `number` | `128` | no |
| entry\_point | The name of a method in the function source which will be invoked when the function is executed. | `string` | n/a | yes |
| environment\_vars | A set of key/value environment variable pairs to assign to the function. | `map(string)` | `{}` | no |
| event\_trigger\_failure\_policy\_retry | A toggle to determine if the function should be retried on failure. | `bool` | `false` | no |
| function\_archive\_bucket\_name | The GCS bucket containing the zip archive which contains the function. | `any` | `null` | no |
| gcp\_function\_role | n/a | `string` | `"roles/cloudfunctions.invoker"` | no |
| gcp\_project | Name of the GCP project | `any` | n/a | yes |
| gcp\_region | n/a | `string` | `"us-central1"` | no |
| gcp\_zone | n/a | `string` | `"us-central1a"` | no |
| ingress\_settings | The ingress settings for the function. Allowed values are ALLOW\_ALL, ALLOW\_INTERNAL\_AND\_GCLB and ALLOW\_INTERNAL\_ONLY. Changes to this field will recreate the cloud function. | `string` | `"ALLOW_ALL"` | no |
| invokers | List of function invokers (i.e. allUsers if you want to Allow unauthenticated) | `list(string)` | `[]` | no |
| max\_instances | The maximum number of parallel executions of the function. | `number` | `0` | no |
| output\_file\_path | n/a | `any` | n/a | yes |
| prjid | (Required) Name of the project/stack e.g: mystack, nifieks, demoaci. Should not be changed after running 'tf apply' | `any` | n/a | yes |
| runtime | (Required) The runtime in which the function is going to run. Eg. python37, go113 | `string` | `"python37"` | no |
| schedule | Describes the schedule on which the job will be executed | `string` | `"*/30 * * * *"` | no |
| schedule\_payload | Payload for Cloud Scheduler | `string` | `"{}"` | no |
| schedule\_retry\_config | By default, if a job does not complete successfully, meaning that an acknowledgement is not received from the handler, then it will be retried with exponential backoff | <pre>object({<br>    retry_count          = number,<br>    max_retry_duration   = string,<br>    min_backoff_duration = string,<br>    max_backoff_duration = string,<br>    max_doublings        = number,<br>  })</pre> | <pre>{<br>  "max_backoff_duration": "3600s",<br>  "max_doublings": 5,<br>  "max_retry_duration": "0s",<br>  "min_backoff_duration": "5s",<br>  "retry_count": 0<br>}</pre> | no |
| schedule\_time\_zone | Specifies the time zone to be used in interpreting schedule. The value of this field must be a time zone name from the tz database | `string` | `"America/Los_Angeles"` | no |
| service\_account\_email | The self-provided service account to run the function with. | `any` | `null` | no |
| sls\_project\_env | Project's SLS environment. | `string` | n/a | yes |
| source\_file | n/a | `any` | n/a | yes |
| teamid | (Required) Name of the team/group e.g. devops, dataengineering. Should not be changed after running 'tf apply' | `any` | n/a | yes |
| timeout | n/a | `number` | `60` | no |
| trigger\_event\_resource | The name or partial URI of the resource from which to observe events. Only for topic and bucket triggered functions | `string` | `""` | no |
| trigger\_event\_type | The type of event to observe. Only for topic and bucket triggered functions | `string` | `""` | no |
| trigger\_type | Function trigger type that must be provided | `string` | n/a | yes |
| vpc\_access\_connector | Enable access to shared VPC 'projects/<host-project>/locations/<region>/connectors/<connector>' | `string` | `null` | no |
| vpc\_connector | The VPC Network Connector that this cloud function can connect to. It should be set up as fully-qualified URI. The format of this field is projects/\*/locations/\*/connectors/\*. | `string` | `null` | no |
| vpc\_connector\_egress\_settings | The egress settings for the connector, controlling what traffic is diverted through it. Allowed values are ALL\_TRAFFIC and PRIVATE\_RANGES\_ONLY. If unset, this field preserves the previously set value. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| function\_http\_url | function http trigger url |
| function\_id | function id |
| function\_memory | function memory |
| function\_name | function name |
| function\_project | function project |
| function\_region | function region |
| function\_runtime | function runtime |
| function\_service\_account\_email | Service account email |
| function\_source\_archive\_bucket | function source archive bucket |
| function\_source\_archive\_object | function source archive object |
| function\_vpc\_egress\_settings | function vpc egress settings |
| scheduler\_topic\_id | n/a |

## Permissions

Service account with the following roles is required:

- [`roles/cloudfunctions.developer`](https://cloud.google.com/iam/docs/understanding-roles#cloud-functions-roles)
- [`roles/storage.admin`](https://cloud.google.com/iam/docs/understanding-roles#cloud-storage-roles)

## Project APIs

Following APIs must be enabled on the project:
- `cloudfunctions.googleapis.com`
- `storage-component.googleapis.com`


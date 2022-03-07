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
  region                       = "us-west2"
  output_file_path             = "/tmp/test.zip"
  source_file                  = "main.py"
  function_archive_bucket_name = module.storage_bucket.storage_bucket_name
  ingress_settings             = "ALLOW_ALL"
  entry_point                  = "function_handler"
  #----------------------------------------
  # NOTE: "trigger_event_type" & "trigger_event_resource" is only required
  # when "trigger_type" is "bucket" or "topic"
  trigger_type           = "topic"
  trigger_event_type     = "google.pubsub.topic.publish"
  trigger_event_resource = "projects/demo-1000/topics/test-seched"
  #sls_project_env        = "dev"
  invokers              = ["allUsers"]
  service_account_email = "terraform@demo-1000.iam.gserviceaccount.com"
  #----------------------------------------
  # Note: Do not change teamid and prjid once set.
  teamid = var.teamid
  prjid  = var.prjid
}

module "storage_bucket" {
  source = "git::git@github.com:tomarv2/terraform-google-storage-bucket.git?ref=v0.0.2"

  bucket_name = "testbucket-schedsdfsdf"
  #----------------------------------------
  # Note: Do not change teamid and prjid once set.
  teamid = var.teamid
  prjid  = var.prjid
}

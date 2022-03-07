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
  function_archive_bucket_name = module.storage_bucket.storage_bucket_name
  ingress_settings             = "ALLOW_ALL"
  entry_point                  = "function_handler"
  #----------------------------------------
  # NOTE: "trigger_event_type" & "trigger_event_resource" is only required
  # when "trigger_type" is "bucket" or "topic"
  trigger_type           = "bucket"
  trigger_event_type     = "google.storage.object.finalize"
  trigger_event_resource = module.storage_bucket.storage_bucket_name
  invokers               = ["allUsers"]
  #----------------------------------------
  # Note: Do not change teamid and prjid once set.
  teamid = var.teamid
  prjid  = var.prjid
}

module "storage_bucket" {
  source = "git::git@github.com:tomarv2/terraform-google-storage-bucket.git?ref=v0.0.2"

  #----------------------------------------
  # Note: Do not change teamid and prjid once set.
  teamid = var.teamid
  prjid  = var.prjid
}

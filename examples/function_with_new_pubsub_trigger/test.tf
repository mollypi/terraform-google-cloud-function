module "cloudfunction" {
  source = "../../"

  gcp_project = "demo-1000"
  environment_vars = {
    "HELLO" = "WORLD"
  }
  output_file_path             = "/tmp/test.zip"
  source_file                  = "main.py"
  function_archive_bucket_name = module.storage_bucket.storage_bucket_name
  ingress_settings             = "ALLOW_ALL"
  entry_point                  = "function_handler"
  #-----------------------------------------------
  # NOTE: "trigger_event_type" & "trigger_event_resource" is only required
  # when "trigger_type" is "bucket" or "topic"
  trigger_type           = "topic"
  trigger_event_type     = "google.pubsub.topic.publish"
  trigger_event_resource = module.pubsub.pubsub_topic_id
  sls_project_env        = "dev"
  invokers               = ["allUsers"]
  service_account_email  = "terraform@demo-1000.iam.gserviceaccount.com"
  #-----------------------------------------------
  # Note: Do not change teamid and prjid once set.
  teamid = var.teamid
  prjid  = var.prjid
}

module "storage_bucket" {
  source = "git::git@github.com:tomarv2/terraform-google-storage-bucket.git"

  bucket_name = "testbucket-vt001"
  gcp_project = "demo-1000"
  #-----------------------------------------------
  # Note: Do not change teamid and prjid once set.
  teamid = var.teamid
  prjid  = var.prjid
}

module "pubsub" {
  source = "git::git@github.com:tomarv2/terraform-google-pubsub.git"
  #source = "../../../terraform-google-pubsub"

  gcp_project = "demo-1000"
  region      = "us-west2"
  #-----------------------------------------------
  # Note: Do not change teamid and prjid once set.
  teamid = var.teamid
  prjid  = var.prjid
}

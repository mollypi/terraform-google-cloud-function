module "cloudfunction" {
  source = "../../"

  gcp_project = "demo-1000"
  environment_vars = {
    "HELLO" = "WORLD"
  }
  output_file_path             = "/tmp/test.zip"
  source_file                  = "main.py"
  function_archive_bucket_name = "demo-bucket"
  ingress_settings             = "ALLOW_ALL"
  entry_point                  = "function_handler"
  #-----------------------------------------------
  # NOTE:
  # trigger_event_type & trigger_event_resource is only required
  # when trigger_type is bucket and topic
  trigger_type           = "bucket"
  trigger_event_type     = "google.storage.object.finalize"
  trigger_event_resource = "demo-bucket"
  sls_project_env        = "dev"
  invokers               = ["allUsers"]
  service_account_email  = "demo@demo-1000.iam.gserviceaccount.com"
  #-----------------------------------------------
  # Note: Do not change teamid and prjid once set.
  teamid = var.teamid
  prjid  = var.prjid
}

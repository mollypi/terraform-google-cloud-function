resource "google_storage_bucket_object" "archive" {
  name   = "${var.teamid}-${var.prjid}-${local.prefix}"
  bucket = var.function_archive_bucket_name
  source = data.archive_file.zip.output_path
}

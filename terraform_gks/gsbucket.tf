resource "google_storage_bucket" "static-site" {
  name          = "${var.project_id}-spinnaker-config"
  location      = var.region
  force_destroy = false
}

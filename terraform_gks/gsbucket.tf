# bucket to store spinnaker config
resource "google_storage_bucket" "static-site" {
  name          = "${var.project_id}-spinnaker-config"
  location      = var.region
  force_destroy = true
}

#bucket to store k8s manifests
resource "google_storage_bucket" "manifests" {
  name          = "${var.project_id}-kubernetes-manifests"
  location      = var.region
  force_destroy = true
}



# Allow use of needed apis for this project
resource "google_project_service" "project" {
  project = var.project_id
  service = "container.googleapis.com"

  disable_dependent_services = true
}
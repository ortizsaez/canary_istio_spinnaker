# Allow use of needed apis for this project
resource "google_project_service" "project" {
  project = var.project_id
  service = "container.googleapis.com"

  disable_dependent_services = true
}
resource "google_project_service" "repos" {
  project = var.project_id
  service = "sourcerepo.googleapis.com"

  disable_dependent_services = true
}

resource "google_project_service" "gcr" {
  project = var.project_id
  service = "containerregistry.googleapis.com"

  disable_dependent_services = true
}

resource "google_project_service" "gcb" {
  project = var.project_id
  service = "cloudbuild.googleapis.com"

  disable_dependent_services = true
}

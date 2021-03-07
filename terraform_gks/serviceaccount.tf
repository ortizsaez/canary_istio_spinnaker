# Create a serviceaccount for spinnaker and give roles
resource "google_service_account" "sa" {
  account_id   = "spinnaker-account"
  display_name = "spinnaker-account"
  depends_on = [ google_project_service.project ]
}

#resource "google_service_account_iam_binding" "admin-account-iam" {
#  service_account_id = google_service_account.sa.name
#  role               = "roles/storage.admin"
#
#  members = [
#    "serviceAccount:${google_service_account.sa.email}",
#  ]
#}

# Add roles to account
resource "google_project_iam_binding" "project" {
  project = var.project_id
  role    = "roles/storage.admin"

  members = [
    "serviceAccount:${google_service_account.sa.email}",
  ]
}

#resource "google_project_iam_binding" "instanceAdmin" {
#  project = var.project_id
#  role    = "roles/compute.instanceAdmin"
#
#  members = [
#    "serviceAccount:${google_service_account.sa.email}",
#  ]
#}
#
#resource "google_project_iam_binding" "networkAdmin" {
#  project = var.project_id
#  role    = "roles/compute.networkAdmin"
#
#  members = [
#    "serviceAccount:${google_service_account.sa.email}",
#  ]
#}
#
#resource "google_project_iam_binding" "serviceAccountActor" {
#  project = var.project_id
#  role    = "roles/iam.serviceAccountActor"
#
#  members = [
#    "serviceAccount:${google_service_account.sa.email}",
#  ]
#}
#


resource "google_pubsub_subscription_iam_binding" "subscriber" {
  subscription = "${google_pubsub_subscription.spinnaker.name}"
  role         = "roles/pubsub.subscriber"
  members = [
    "serviceAccount:${google_service_account.sa.email}",
  ]
}


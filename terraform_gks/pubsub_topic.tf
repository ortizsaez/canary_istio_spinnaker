# Subscription to associate with spinnaker pipelines
resource "google_pubsub_topic" "spinnaker" {
  name = "spinnaker-topic"
}

resource "google_pubsub_subscription" "spinnaker" {
  name  = "spinnaker-subscription"
  topic = google_pubsub_topic.spinnaker.name

  ack_deadline_seconds = 20
}


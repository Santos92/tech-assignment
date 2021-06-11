module "pubsub" {
  source  = "terraform-google-modules/pubsub/google"
  version = "~> 1.8"

  topic      = var.topic_name
  project_id = var.project_id
  pull_subscriptions = [
    {
      name                    = var.subscription_name
      ack_deadline_seconds    = 20
    }
  ]
}

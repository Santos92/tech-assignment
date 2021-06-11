resource "google_service_account" "sa" {
  account_id   = var.account_id_event
  display_name = var.display_name_event
  project      = var.project_id
}

resource "google_project_iam_member" "project_roles" {
  project = var.project_id
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:${google_service_account.sa.email}"

  depends_on = [google_service_account.sa]
}

resource "google_service_account" "ci_cd_sa" {
  account_id   = var.account_id_ci_cd
  display_name = var.display_name_ci_cd
  project      = var.project_id
}

resource "google_project_iam_member" "project_role_ci_cd" {
  project = var.project_id
  role    = "roles/run.admin"
  member  = "serviceAccount:${google_service_account.ci_cd_sa.email}"

  depends_on = [google_service_account.ci_cd_sa]
}

resource "google_project_iam_custom_role" "gke_custom_role" {  
  project     = var.project_id
  role_id     = "cicd.gke.manager"
  title       = "CI/CD GKE manager role"
  description = "Custom role for minimal access to GKE"
  permissions = ["container.apiServices.get", "container.apiServices.list", "container.clusters.get", "container.clusters.getCredentials", "container.clusters.list"]
}

resource "google_project_iam_member" "project_role_ci_cd_gke" {
  project = var.project_id
  role    = google_project_iam_custom_role.gke_custom_role.id
  member  = "serviceAccount:${google_service_account.ci_cd_sa.email}"

  depends_on = [google_project_iam_custom_role.gke_custom_role]
}

resource "google_project_iam_member" "project_role_ci_cd_storage" {
  project = var.project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.ci_cd_sa.email}"

  depends_on = [google_service_account.ci_cd_sa]
}

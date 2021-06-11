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

/*
  -----------------------------------------------------------------------------
                           CENTRALIZED HOME FOR STATE
                           inerpolations NOT allowed
  -----------------------------------------------------------------------------
*/
terraform {
  backend "gcs" {
    bucket = "tfstate-edu-gcp-labs"
  }
}

/*
  --------------------------------------------------------|------------------------------------------------------------
                                                      TERRAFORM
  ---------------------------------------------------------------------------------------------------------------------
*/
# Check Releases here: version numbers tend to match, and should
# https://github.com/hashicorp/terraform-provider-google/releases
# https://github.com/hashicorp/terraform-provider-google-beta/releases
terraform {
  required_version = "~> 1.2.9"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "< 5.0.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "< 5.0.0"
    }
  }
}

/*
  --------------------------------------------------------|------------------------------------------------------------
                                                       PROJECT
  ---------------------------------------------------------------------------------------------------------------------
*/
provider "google" {
  region  = var.region
  project = var.project_id
}

provider "google-beta" {
  region  = var.region
  project = var.project_id
}

/*
  --------------------------------------------------------|------------------------------------------------------------
                                                      KUBERNETES
  ---------------------------------------------------------------------------------------------------------------------
*/
data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

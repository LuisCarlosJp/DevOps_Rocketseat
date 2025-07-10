terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.43.0"
    }
  }
}

provider "google" {
  project = "rocketseat-luiscarlosjp"
  region  = "us-central1"
}



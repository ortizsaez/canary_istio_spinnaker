terraform {
  required_version = ">= 0.12.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.52.0"
    }
  }
}

# Configure the Google provider
#provider "google" {
#  features {}
#}


## We can define more modules
# module "two_vnets" {
#
#}

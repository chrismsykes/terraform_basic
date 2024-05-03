terraform {
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "~> 2.0"
    }
  }
}

provider "vsphere" {
  user           = "username"
  password       = "password"
  vsphere_server = "url"

  # If you have a self-signed cert
  allow_unverified_ssl = true
}
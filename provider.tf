terraform {
  # Terraform Cloud workspace oci-temp-monitor still runs 1.2.1
  required_version = ">= 1.2"

  required_providers {
    oci = {
      # Same releases as oracle/oci; kept as hashicorp/oci to match the state
      source  = "hashicorp/oci"
      version = "~> 9.14"
    }
    cloudflare = {
      # v5 renames cloudflare_record; migrate separately (via 4.52.5 first)
      source  = "cloudflare/cloudflare"
      version = "~> 4.52"
    }
    acme = {
      source  = "vancluever/acme"
      version = "~> 2.48.3"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }

  backend "remote" {
    organization = "mygermanium"

    workspaces {
      name = "oci-temp-monitor"
    }
  }
}

provider "oci" {
  region       = "eu-frankfurt-1"
  tenancy_ocid = var.TENANCY_OCID
  user_ocid    = var.USER_OCID
  fingerprint  = var.FINGERPRINT
  private_key  = var.PRIVATE_KEY
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

provider "acme" {
  # Staging (use first when testing, production has rate limits):
  # server_url = "https://acme-staging-v02.api.letsencrypt.org/directory"
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}

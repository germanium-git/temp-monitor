terraform {
   required_providers {
      oci = {
         source = "hashicorp/oci"
      }
      cloudflare = {
         source = "cloudflare/cloudflare"
      }
      acme = {
            source  = "vancluever/acme"
            version = "~> 2.10.0"
        }
   }
   backend "remote" {
   # The name of your Terraform Cloud organization.
      organization = "mygermanium"

    # The name of the Terraform Cloud workspace to store Terraform state files in.
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
  # Staging
  server_url = "https://acme-staging-v02.api.letsencrypt.org/directory"
  
  # Production
  #server_url = "https://acme-v02.api.letsencrypt.org/directory"
  
}
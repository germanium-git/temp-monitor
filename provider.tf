terraform {
   required_providers {
      oci = {
         source = "hashicorp/oci"
      }
   }
}


provider "oci" {
   region = "eu-frankfurt-1"
   tenancy_ocid = var.tenancy_ocid
   user_ocid = var.user_ocid
   fingerprint = var.fingerprint
   private_key = var.private_key
}

terraform {
   required_providers {
      oci = {
         source = "hashicorp/oci"
      }
   }
}


provider "oci" {
   region = "eu-frankfurt-1"
   tenancy_ocid = var.TENANCY_OCID
   user_ocid = var.USER_OCID
   fingerprint = var.FINGERPRINT
   private_key = var.PRIVATE_KEY
}

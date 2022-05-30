terraform {
   required_providers {
      oci = {
         source = "hashicorp/oci"
      }
   }
}


provider "oci" {
   region = "eu-frankfurt-1"
}

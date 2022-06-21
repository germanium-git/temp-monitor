# Get all availability domains for the region
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.TENANCY_OCID
}

# okdB:EU-FRANKFURT-1-AD-1, okdB:EU-FRANKFURT-1-AD-2, okdB:EU-FRANKFURT-1-AD-3


# Get latest Oracle Linux 8 image for ARM-based processor
data "oci_core_images" "oraclelinux-8" {
  compartment_id = var.COMPARTMENT_OCID
  operating_system = "Oracle Linux"
  operating_system_version = "8"
  shape = "VM.Standard.A1.Flex"
  filter {
    name = "display_name"
    values = ["^Oracle-Linux-8.6-aarch64-([\\.0-9-]+)$"]
    regex = true
  }
}

output "oracle-linux-8-latest-name" {
  value = data.oci_core_images.oraclelinux-8.images.0.display_name
}

output "oracle-linux-8-latest-id" {
  value = data.oci_core_images.oraclelinux-8.images.0.id
}


/*
resource "oci_core_instance" "apollo" {
  # Required
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  #availability_domain = "okdB:EU-FRANKFURT-1-AD-1"
  compartment_id      = var.COMPARTMENT_OCID
  #shape              = "VM.Standard.E2.1.Micro"
  shape               = "VM.Standard.A1.Flex"

  source_details {
    source_id   = data.oci_core_images.oraclelinux-8.id
    source_type = "image"
  }

  # Optional
  display_name = "apollo"

  shape_config {
    ocpus         = 1
    memory_in_gbs = 6
  }

  create_vnic_details {
    assign_public_ip = true
    subnet_id        = oci_core_subnet.influx_subnet_01.id
    nsg_ids          = [oci_core_network_security_group.influx_nsg.id]
  }

  metadata = {
    ssh_authorized_keys = file("sshkey/oracle-cloud_2021-09-08_id_rsa.pub")
  }

  preserve_boot_volume = false
}


# Outputs for compute instance
output "public-ip-apollo" {
  value = oci_core_instance.apollo.public_ip
}

*/
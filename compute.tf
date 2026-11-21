# Instance and data volume must be in the same availability domain
locals {
  availability_domain = "okdB:EU-FRANKFURT-1-AD-2"
}

# Newest Canonical Ubuntu 24.04 image for Ampere A1 (aarch64)
data "oci_core_images" "ubuntu_2404_a1" {
  compartment_id           = var.COMPARTMENT_OCID
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "24.04"
  shape                    = "VM.Standard.A1.Flex"
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

resource "oci_core_instance" "apollo" {
  availability_domain = local.availability_domain
  compartment_id      = var.COMPARTMENT_OCID
  display_name        = var.server_name

  # Always Free A1 allowance is 2 OCPU / 12 GB in total. Starting at 1 / 6
  # because AD-2 had no capacity for 2 / 12; resize in place once it has.
  shape = "VM.Standard.A1.Flex"
  shape_config {
    ocpus         = 1
    memory_in_gbs = 6
  }

  source_details {
    source_type             = "image"
    source_id               = data.oci_core_images.ubuntu_2404_a1.images[0].id
    boot_volume_size_in_gbs = 50
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

  lifecycle {
    # A newer image must not rebuild the VM. Rebuild deliberately with
    # terraform apply -replace=oci_core_instance.apollo
    ignore_changes = [source_details[0].source_id]
  }
}

output "public-ip-apollo" {
  value = oci_core_instance.apollo.public_ip
}

output "apollo-image" {
  value = data.oci_core_images.ubuntu_2404_a1.images[0].display_name
}

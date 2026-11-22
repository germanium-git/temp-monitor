# Instance and data volume must be in the same availability domain
locals {
  availability_domain = "okdB:EU-FRANKFURT-1-AD-2"
}

# Newest Canonical Ubuntu 24.04 Minimal image for the Always Free AMD micro
# shape (x86_64). Minimal keeps memory use down on the 1 GB VM.
# A1 (Ampere) capacity was unavailable in AD-2, so apollo runs on E2.1.Micro.
data "oci_core_images" "ubuntu_2404_micro" {
  compartment_id           = var.COMPARTMENT_OCID
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "24.04 Minimal"
  shape                    = "VM.Standard.E2.1.Micro"
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

resource "oci_core_instance" "apollo" {
  availability_domain = local.availability_domain
  compartment_id      = var.COMPARTMENT_OCID
  display_name        = var.server_name

  # Always Free: fixed 1/8 OCPU, 1 GB RAM. No shape_config for a fixed shape.
  shape = "VM.Standard.E2.1.Micro"

  source_details {
    source_type             = "image"
    source_id               = data.oci_core_images.ubuntu_2404_micro.images[0].id
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
  value = data.oci_core_images.ubuntu_2404_micro.images[0].display_name
}

# InfluxDB data. Survives VM rebuilds; never let Terraform delete it.
resource "oci_core_volume" "volume_100" {
  compartment_id      = var.COMPARTMENT_OCID
  availability_domain = local.availability_domain
  display_name        = "volume_100GB"
  size_in_gbs         = 100

  lifecycle {
    prevent_destroy = true
  }
}

resource "oci_core_volume_attachment" "test_volume_attachment" {
  attachment_type = "paravirtualized"
  instance_id     = oci_core_instance.apollo.id
  volume_id       = oci_core_volume.volume_100.id
}

resource "oci_core_volume" "volume_200" {
    #Required
    compartment_id = var.COMPARTMENT_OCID

    #Optional
    availability_domain = "okdB:EU-FRANKFURT-1-AD-2"
    size_in_gbs = 200
}

resource "oci_core_volume_attachment" "test_volume_attachment" {
    #Required
    attachment_type = "paravirtualized"
    instance_id = oci_core_instance.apollo.id
    volume_id = oci_core_volume.volume_200.id
}
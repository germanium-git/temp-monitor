resource "oci_core_vcn" "vcn1" {
  cidr_block     = "10.1.0.0/16"
  compartment_id = var.influxdb_compartment_ocid
  display_name   = "influx-vcn"
}

resource "oci_core_subnet" "influx_subnet_01" {
  cidr_block        = "10.1.1.0/24"
  display_name      = "influx_subnet_01"
  compartment_id    = var.influxdb_compartment_ocid
  vcn_id            = oci_core_vcn.vcn1.id
  security_list_ids = [oci_core_vcn.vcn1.default_security_list_id]
  route_table_id    = oci_core_vcn.vcn1.default_route_table_id
}

# Virtual Cloud Networks
resource "oci_core_vcn" "vcn1" {
  cidr_block     = "10.1.0.0/16"
  compartment_id = var.COMPARTMENT_OCID
  display_name   = "influx-vcn"
}

# Subnet
resource "oci_core_subnet" "influx_subnet_01" {
  cidr_block        = "10.1.1.0/24"
  display_name      = "influx_subnet_01"
  compartment_id    = var.COMPARTMENT_OCID
  vcn_id            = oci_core_vcn.vcn1.id
  security_list_ids = [oci_core_vcn.vcn1.default_security_list_id]
  route_table_id    = oci_core_vcn.vcn1.default_route_table_id
}


resource "oci_core_network_security_group" "influx_nsg" {
  #Required
  compartment_id = var.COMPARTMENT_OCID
  vcn_id         = oci_core_vcn.vcn1.id

  #Optional
  display_name = "influx-nsg"
}


resource "oci_core_network_security_group_security_rule" "test_network_security_group_security_rule_1" {
  network_security_group_id = oci_core_network_security_group.influx_nsg.id
  source_type               = "CIDR_BLOCK"
  source                    = var.myIp
  direction                 = "INGRESS"
  protocol                  = "all"
  stateless                 = false
}

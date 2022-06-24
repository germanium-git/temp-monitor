# Virtual Cloud Networks
resource "oci_core_vcn" "vcn1" {
  cidr_block     = "10.1.0.0/16"
  compartment_id = var.COMPARTMENT_OCID
  display_name   = "influx-vcn"
}

# Subnet 01
resource "oci_core_subnet" "influx_subnet_01" {
  cidr_block        = "10.1.1.0/24"
  display_name      = "influx_subnet_01"
  compartment_id    = var.COMPARTMENT_OCID
  vcn_id            = oci_core_vcn.vcn1.id
  security_list_ids = [oci_core_vcn.vcn1.default_security_list_id]
  route_table_id    = oci_core_vcn.vcn1.default_route_table_id
}



# CREATE INTERNET GATEWAY
resource oci_core_internet_gateway "igw" {
  compartment_id = var.COMPARTMENT_OCID
  defined_tags = {
  }
  display_name = '${local.name}-igw'
  enabled      = "true"
  freeform_tags = {
  }
  vcn_id = oci_core_vcn.vcn1.id
}


# Subnet 02
resource "oci_core_subnet" "influx_subnet_02" {
  cidr_block        = "10.1.2.0/24"
  display_name      = "influx_subnet_02"
  compartment_id    = var.COMPARTMENT_OCID
  vcn_id            = oci_core_vcn.vcn1.id
  security_list_ids = [oci_core_vcn.vcn1.default_security_list_id]
  route_table_id    = oci_core_vcn.vcn1.default_route_table_id
}


# DEFINE A ROUTE TABLE
resource oci_core_default_route_table "route_table" {
  defined_tags = {
  }
  display_name = "Default Route Table for ${oci_core_vcn.vcn1.display_name}"
  freeform_tags = {
  }
  manage_default_resource_id = oci_core_vcn.vcn1.default_route_table_id
  route_rules {
    #description = <<Optional value not found in discovery>>
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.igw.id
  }
}



# NSG
resource "oci_core_network_security_group" "influx_nsg" {
  #Required
  compartment_id = var.COMPARTMENT_OCID
  vcn_id         = oci_core_vcn.vcn1.id

  #Optional
  display_name = "influx-nsg"
}

# NSG Rule
resource "oci_core_network_security_group_security_rule" "test_network_security_group_security_rule_1" {
  network_security_group_id = oci_core_network_security_group.influx_nsg.id
  source_type               = "CIDR_BLOCK"
  source                    = var.myIp
  direction                 = "INGRESS"
  protocol                  = "all"
  stateless                 = false
}

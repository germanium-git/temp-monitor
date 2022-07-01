variable "TENANCY_OCID" {
  type = string
}
variable "USER_OCID" {
  type = string
}
variable "FINGERPRINT" {
  type = string
}
variable "PRIVATE_KEY" {
  type = string
}
variable "COMPARTMENT_OCID" {
  type = string
}

# Use CIDR format
variable "myIp" {
  default = "185.230.172.74/32"
}


#
locals {
  name = "influxdb"
}

# --Network Security Group rules protecting the VM(s)
variable "nsg_rules" {
  description = "Network Security Group"
  type = map(list(string))

  # Structure is as follows name = [description, source, protocol, dst_port_range]
  default = {
    SSH   = ["SSH from my public IP", "185.230.172.74/32", "TCP", "22"]
  }
}

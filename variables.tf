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

# The value is is stored in TF Cloud as a sensitive variable
variable "cloudflare_api_token" {
  description = "A valid Cloudflare token with permission to create DNS records"
  type = string
}


# The value is is stored in TF Cloud as a sensitive variable
variable "cloudflare_zone_id" {
  description = "Cloudflare Zone ID"
  type = string
}


locals {
  name = "influxdb"
}

# --Network Security Group rules protecting the VM(s)
variable "nsg_rules" {
  description = "Network Security Group"
  type = map(list(string))

  # Structure is as follows name = [description, source, protocol, dst_port_range]
  # protocol - Specify either all or an IPv4 protocol number as defined in Protocol Numbers
  # Options are supported only for ICMP ("1"), TCP ("6"), UDP ("17"), and ICMPv6 ("58").
  default = {
    SSH   = ["SSH from my public IP", "185.230.172.74/32", "6", "22"]
    SSH_TE   = ["SSH from TE", "131.207.0.0/16", "6", "22"]
    influx   = ["InfluxDB my public IP", "185.230.172.74/32", "6", "8086"]
    influx_TE   = ["InfluxDB from TE", "131.207.0.0/16", "6", "8086"]
  }
}

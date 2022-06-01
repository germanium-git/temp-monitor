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
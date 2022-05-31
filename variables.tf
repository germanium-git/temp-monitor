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

# Pre-Authenticated Requests to talk to the backend on object storage in Oracle cloud
variable "PREAUTH_REQUEST" {
  type = string
}
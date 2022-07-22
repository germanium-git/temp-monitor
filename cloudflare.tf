# Create A record in Cloudflare DNS for the compute node
resource "cloudflare_record" "apollo" {
  zone_id = var.cloudflare_zone_id
  name    = "apollo"
  value   = oci_core_instance.apollo.public_ip
  type    = "A"
}

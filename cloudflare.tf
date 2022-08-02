# Create A record in Cloudflare DNS for the compute node
resource "cloudflare_record" "apollo" {
  zone_id = var.cloudflare_zone_id
  name    = var.server_name
  value   = oci_core_instance.apollo.public_ip
  type    = "A"
}

data "cloudflare_zone" "zone" {
  zone_id = var.cloudflare_zone_id
}
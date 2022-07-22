# Create A record in Cloudflare DNS for the compute node
resource "cloudflare_record" "root" {
  zone_id = var.cloudflare_zone_id
  name    = "apollo"
  value   = public-ip-apollo
  type    = "A"
}


resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

resource "acme_registration" "registration" {
  account_key_pem = tls_private_key.private_key.private_key_pem
  email_address   = var.email_address 
}


resource "acme_certificate" "certificate" {
  account_key_pem           = acme_registration.registration.account_key_pem
  common_name               = "${var.server_name}.${data.cloudflare_zone.zone.name}"

  dns_challenge {
    provider = "cloudflare"

    config = {
      CF_DNS_API_TOKEN = var.cloudflare_api_token
    }
  }
}


output "certificate_pem" {
  value = lookup(acme_certificate.certificate, "certificate_pem")
}

output "issuer_pem" {
  value = lookup(acme_certificate.certificate, "issuer_pem")
}

output "private_key_pem" {
  value = nonsensitive(lookup(acme_certificate.certificate, "private_key_pem"))
}

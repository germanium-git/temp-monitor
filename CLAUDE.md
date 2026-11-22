# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Terraform for a single Oracle Cloud (OCI, `eu-frankfurt-1`) VM named `apollo` that hosts InfluxDB for temperature monitoring. Cloudflare gives it a DNS name, and Let's Encrypt (through the ACME provider) issues its TLS certificate. There's no application code here, only infrastructure.

## Commands

State and variables live in **Terraform Cloud**: remote backend, org `mygermanium`, workspace `oci-temp-monitor`. Plans and applies run there, so local commands need `terraform login` first.

```sh
terraform init
terraform fmt            # CI runs `terraform fmt -check` (non-blocking)
terraform validate
terraform plan -input=false
```

CI (`.github/workflows/terraform.yml`) runs init, fmt and plan on every PR. **A push to `main` runs `terraform apply -auto-approve`**, so every commit to `main` is a production deploy. Changes to the instance, volume or certificate can destroy or recreate real resources. Read the plan before merging.

There are no tests. `terraform validate` and `plan` are the checks.

## Architecture

The dependency chain spans several files:

- `network.tf`: VCN `10.1.0.0/16` with two subnets, an internet gateway and a default route. A Network Security Group gets one ingress rule per entry in `var.nsg_rules` (`variables.tf`), a map of `name = [description, source CIDR, protocol number, port]`. Every rule uses `tcp_options`, so only TCP rules work as written.
- `compute.tf`: `oci_core_instance.apollo`, an Always Free `VM.Standard.E2.1.Micro` instance (x86, 1 GB RAM, fixed shape, so no `shape_config`). It is in `local.availability_domain` (AD-2) and runs the newest Canonical Ubuntu 24.04 Minimal image for that shape (Minimal to save RAM). A1 Flex was dropped because AD-2 had no capacity for it. `ignore_changes` on the image ID means a newer image never rebuilds the VM; to rebuild it deliberately, run `terraform apply -replace=oci_core_instance.apollo`. The SSH key comes from `sshkey/*.pub` (public key only; the private key is gitignored as `key`).
- `storage.tf`: a 100 GB block volume (`prevent_destroy`) holding InfluxDB data, paravirtualized-attached to `apollo`. It uses the same `local.availability_domain`. Always Free block storage is 200 GB in total: 50 GB boot plus 100 GB data.
- `cloudflare.tf`: an A record `var.server_name` pointing at the instance's public IP. The zone is looked up with `var.cloudflare_zone_id`.
- `acme.tf`: the Let's Encrypt certificate has been removed and the file is now only a placeholder. The `acme` and `tls` providers in `provider.tf` stay until the apply that destroys the old ACME resources has run.
- Nothing in Terraform installs software on the VM. InfluxDB is set up by hand, and the NSG already allows TCP 8086.

## Variables

The OCI credentials (`TENANCY_OCID`, `USER_OCID`, `FINGERPRINT`, `PRIVATE_KEY`, `COMPARTMENT_OCID`) and `cloudflare_api_token` / `cloudflare_zone_id` are set as sensitive variables in the Terraform Cloud workspace. They are not in the repo. `terraform.tfvars` is gitignored and only for local use.

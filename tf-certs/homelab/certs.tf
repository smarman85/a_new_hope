provider "aws" {}

provider "acme" {
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}

resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

resource "acme_registration" "reg" {
  account_key_pem = "${tls_private_key.private_key.private_key_pem}"
  email_address   = "seanmarman@gmail.com"
}

resource "acme_certificate" "homelab_xyz" {
  account_key_pem           = "${acme_registration.reg.account_key_pem}"
  common_name               = "seanhome.xyz"
  subject_alternative_names = ["*.seanhome.xyz"]

  dns_challenge {
    #provider = "route53"
    provider = "dnsimple"
  }
}

resource "local_file" "homelab_xyz_key" {
  content  = "${acme_certificate.homelab_xyz.private_key_pem}"
  filename = "ssl/seanhome.xyz.key"
}

resource "local_file" "homelab_xyz_issue" {
  content  = "${acme_certificate.homelab_xyz.certificate_pem}"
  filename = "ssl/seanhome.xyz.pem"
}

resource "local_file" "homelab_xyz_chain" {
  content  = "${acme_certificate.homelab_xyz.issuer_pem}"
  filename = "ssl/seanhome.xyz.chain"
}

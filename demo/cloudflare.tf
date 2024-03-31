provider "cloudflare" {
  api_token = var.CF_TOKEN
}

resource "cloudflare_zone" "demo" {
  account_id = var.CF_ACCOUNT_ID
  zone = var.DNS_NAME
}

resource "cloudflare_record" "demo" {
    zone_id = var.CF_ZONE_ID
    comment = "homelab cname for alb"
    name    = var.DNS_NAME
    value   = aws_lb.demo.dns_name
    type    = "CNAME"
    proxied = true
    ttl     = 1
}

resource "cloudflare_record" "demo_www" {
    zone_id = var.CF_ZONE_ID
    allow_overwrite = false
    name    = "www"
    value   = var.DNS_NAME
    type    = "CNAME"
    proxied = true
    ttl     = 1
}

resource "cloudflare_record" "demo_mailstore" {
    zone_id = var.CF_ZONE_ID
    name    = var.DNS_NAME
    value   = "mailstore1.secureserver.net"
    type    = "MX"
    proxied = false
    priority = 10
    ttl     = 1
}

resource "cloudflare_record" "demo_smtp" {
    zone_id = var.CF_ZONE_ID
    name    = var.DNS_NAME
    value   = "smtp.secureserver.net"
    type    = "MX"
    proxied = false
    priority = 0
    ttl     = 1
}
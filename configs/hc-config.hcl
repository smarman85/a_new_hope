listener "tcp" {
  address            = "<HOST IP ADDR>:8200"
  cluster_address    = "<HOST IP ADDR>:8201"
  tls_disable        = "false"
  tls_cert_file      = "/tmp/cert.pem"
  tls_key_file       = "/tmp/key.pem"
  tls_client_ca_file = "/tmp/chain.pem"
}

storage "inmem" {}

# Config for the CLI
listener "tcp" {
  address     = "127.0.0.1:8200"
  api_addr    = "127.0.0.1:8300"
  tls_disable = "true"
}

api_addr     = "https://<HOST IP ADDR>:8200"
cluster_addr = "https://<HOST IP ADDR>:8201"
disable_mlock = "true"


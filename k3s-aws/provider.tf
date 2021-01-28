provider "aws" {
  profile    = homelab
  region     = var.aws_region
}

provider "tls" {
}



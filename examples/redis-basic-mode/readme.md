# Basic standalone redis example
```
provider "google" {
  credentials = file("<service_account_key_json/p12_file")
  project     = "<project-id>"
  region      = "us-east1"
}

module "redis" {
  source                 = "OT-CLOUD-KIT/redis/gcp"
  vpc_network            = "squadup-vpc"
  primary_zone_id        = "us-east1-b"
  use_private_g_services = true
}
```
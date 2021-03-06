module "redis" {
  source                  = "OT-CLOUD-KIT/redis/gcp"
  vpc_network             = "squadup-vpc"
  primary_zone_id         = "us-east1-b"
  use_private_g_services  = true
  auth_enabled            = true
  transit_encryption_mode = "SERVER_AUTHENTICATION"
  service_tier            = "STANDARD_HA"
}
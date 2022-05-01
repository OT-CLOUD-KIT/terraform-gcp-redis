module "redis" {
  source                 = "../../"
  vpc_network            = "squadup-vpc"
  primary_zone_id        = "us-east1-b"
  use_private_g_services = true
}
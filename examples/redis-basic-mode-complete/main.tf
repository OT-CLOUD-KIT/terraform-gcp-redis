module "redis" {
  source                  = "OT-CLOUD-KIT/redis/gcp"
  vpc_network             = "squadup-vpc"
  primary_zone_id         = "us-east1-b"
  use_private_g_services  = true
  redis_version           = "REDIS_6_X"
  auth_enabled            = true
  transit_encryption_mode = "SERVER_AUTHENTICATION"

  ############ configure redis tuning parameters ################
  redis_config_parameters = {
    activedefrag = "yes"
  }
  ############ configure maintainence window ################
  maintenance_policy = {
    description = "Maintainence on Saturday"
    weekly_maintenance_window = {
      day = "SATURDAY"
      start_time = {
        hours   = 6
        minutes = 30
        seconds = 15
        nanos   = 0
      }
    }
  }
}
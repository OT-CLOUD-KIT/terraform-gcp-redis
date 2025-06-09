name               = "redis-ha"
region             = "us-central1"
tier               = "STANDARD_HA"
memory_size_gb     = 4
authorized_network = "projects/nw-opstree-dev-landing-zone/global/networks/default"

redis_version           = "REDIS_6_X"
connect_mode            = "DIRECT_PEERING"
transit_encryption_mode = "DISABLED"
read_replicas_mode      = "READ_REPLICAS_DISABLED"
labels = {
  env = "dev"
}

timeouts = {
  create = "20m"
  update = "20m"
  delete = "20m"
}

# Uncomment if needed
# persistence_config = {
#   persistence_mode         = "RDB"
#   rdb_snapshot_period      = "TWENTY_FOUR_HOURS"
#   rdb_snapshot_start_time  = "2024-01-01T05:00:00Z"
# }

# maintenance_policy = {
#   day     = "SATURDAY"
#   hours   = 3
#   minutes = 30
#   seconds = 0
# }

project = "nw-opstree-dev-landing-zone"
module "gcp_redis" {
  source = "./module"

  name               = var.name
  region             = var.region
  tier               = var.tier
  memory_size_gb     = var.memory_size_gb
  authorized_network = var.authorized_network

  redis_version           = var.redis_version
  connect_mode            = var.connect_mode
  transit_encryption_mode = var.transit_encryption_mode
  read_replicas_mode      = var.read_replicas_mode
  labels                  = var.labels
  project                 = var.project

  persistence_config   = var.persistence_config
  maintenance_policy   = var.maintenance_policy
  timeouts             = var.timeouts
}
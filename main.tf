resource "google_redis_instance" "inmemory-storage" {
  name               = var.name
  region             = var.region
  tier               = var.tier
  memory_size_gb     = var.memory_size_gb
  redis_version      = var.redis_version
  connect_mode       = var.connect_mode
  authorized_network = var.authorized_network

  project = var.project

  dynamic "persistence_config" {
    for_each = var.persistence_config != null ? [1] : []
    content {
      persistence_mode    = var.persistence_config.persistence_mode
      rdb_snapshot_period = var.persistence_config.rdb_snapshot_period
      rdb_snapshot_start_time = var.persistence_config.rdb_snapshot_start_time
    }
  }

  dynamic "maintenance_policy" {
    for_each = var.maintenance_policy != null ? [1] : []
    content {
      weekly_maintenance_window {
        day        = var.maintenance_policy.day
        start_time {
          hours   = var.maintenance_policy.hours
          minutes = var.maintenance_policy.minutes
          seconds = var.maintenance_policy.seconds
          nanos   = 0
        }
      }
    }
  }

  transit_encryption_mode = var.transit_encryption_mode
  read_replicas_mode      = var.read_replicas_mode
  labels                  = var.labels

  timeouts {
    create = var.timeouts.create
    delete = var.timeouts.delete
    update = var.timeouts.update
  }
}
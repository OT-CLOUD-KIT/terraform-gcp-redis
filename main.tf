resource "google_redis_instance" "inmemory-storage" {
  name               = var.name
  region             = var.region
  tier               = var.tier
  memory_size_gb     = var.memory_size_gb
  redis_version      = var.redis_version
  connect_mode       = var.connect_mode
  authorized_network = var.authorized_network
  count              = var.deployment_mode == "instance" ? 1 : 0
  project            = var.project

  dynamic "persistence_config" {
    for_each = var.persistence_config != null ? [1] : []
    content {
      persistence_mode        = var.persistence_config.persistence_mode
      rdb_snapshot_period     = var.persistence_config.rdb_snapshot_period
      rdb_snapshot_start_time = var.persistence_config.rdb_snapshot_start_time
    }
  }

  dynamic "maintenance_policy" {
    for_each = var.maintenance_policy != null ? [1] : []
    content {
      weekly_maintenance_window {
        day = var.maintenance_policy.day
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

resource "google_network_connectivity_service_connection_policy" "redis_cluster" {
  count = (
    var.deployment_mode == "cluster" &&
    var.cluster_create_service_connection_policy
  ) ? 1 : 0

  project       = var.project
  name          = var.cluster_service_connection_policy_name
  location      = var.region
  service_class = "gcp-memorystore-redis"
  network       = var.cluster_network

  psc_config {
    subnetworks = var.cluster_psc_subnetworks
    limit       = var.cluster_psc_connection_limit
  }

  lifecycle {
    precondition {
      condition = (
        var.cluster_network != null &&
        length(var.cluster_psc_subnetworks) > 0
      )
      error_message = "Redis Cluster PSC policy requires cluster_network and at least one existing PSC subnet."
    }
  }
}

resource "google_redis_cluster" "this" {
  count = var.deployment_mode == "cluster" ? 1 : 0

  project       = var.project
  name          = var.name
  region        = var.region
  shard_count   = var.cluster_shard_count
  replica_count = var.cluster_replica_count
  node_type     = var.cluster_node_type

  psc_configs {
    network = var.cluster_network
  }

  zone_distribution_config {
    mode = var.cluster_multi_zone ? "MULTI_ZONE" : "SINGLE_ZONE"
  }

  transit_encryption_mode     = var.cluster_transit_encryption_mode
  authorization_mode          = var.cluster_authorization_mode
  deletion_protection_enabled = var.cluster_deletion_protection_enabled

  kms_key       = var.cluster_kms_key
  redis_configs = var.cluster_redis_configs
  labels        = var.labels

  depends_on = [
    google_network_connectivity_service_connection_policy.redis_cluster
  ]

  lifecycle {
    precondition {
      condition = (
        var.cluster_network != null &&
        length(var.cluster_network) > 0
      )
      error_message = "cluster_network is required for Redis Cluster PSC."
    }

    precondition {
      condition = (
        !var.cluster_create_service_connection_policy ||
        length(var.cluster_psc_subnetworks) > 0
      )
      error_message = "Provide cluster_psc_subnetworks when creating the PSC service connection policy."
    }

    precondition {
      condition = (
        var.cluster_replica_count >= 1 ||
        !var.cluster_multi_zone
      )
      error_message = "For this HA wrapper configuration, use at least one replica per shard with multi-zone distribution."
    }
  }
}

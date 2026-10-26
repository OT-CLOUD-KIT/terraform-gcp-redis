
module "gcp_redis" {
  source = "../../"

  deployment_mode = "cluster"

  project = var.project
  name    = var.name
  region  = var.region
  labels  = var.labels

    # Required by the existing legacy Redis module interface.
  # Not used when deployment_mode = "cluster".
  tier              = "STANDARD_HA"
  memory_size_gb    = 1
  authorized_network = var.cluster_network

  cluster_shard_count   = var.cluster_shard_count
  cluster_replica_count = 1
  cluster_node_type     = "REDIS_HIGHMEM_MEDIUM"
  cluster_multi_zone    = true

  cluster_network = var.cluster_network

  cluster_create_service_connection_policy = true
  cluster_service_connection_policy_name   = "${var.name}-psc-policy"
  cluster_psc_subnetworks                  = var.cluster_psc_subnetworks
  cluster_psc_connection_limit             = 2

  cluster_transit_encryption_mode = "TRANSIT_ENCRYPTION_MODE_SERVER_AUTHENTICATION"
  cluster_authorization_mode      = "AUTH_MODE_IAM_AUTH"

  cluster_kms_key = var.cluster_kms_key

  cluster_deletion_protection_enabled = true

  cluster_redis_configs = {
    "maxmemory-policy" = "volatile-ttl"
  }
}

output "redis_cluster_endpoint" {
  value = module.gcp_redis.cluster_discovery_endpoint
}

output "redis_cluster_port" {
  value = module.gcp_redis.cluster_discovery_port
}

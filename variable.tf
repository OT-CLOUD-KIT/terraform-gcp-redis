variable "name" {
  description = "The name of the Redis instance"
  type        = string
}

variable "region" {
  description = "The region to deploy Redis in"
  type        = string
}

variable "tier" {
  description = "The service tier: BASIC or STANDARD_HA"
  type        = string
}

variable "memory_size_gb" {
  description = "The size of Redis memory in GB"
  type        = number
}

variable "authorized_network" {
  description = "VPC network self link for Redis instance"
  type        = string
}

variable "project" {
  description = "GCP project ID"
  type        = string
  default     = null
}

variable "redis_version" {
  description = "Redis version"
  type        = string
  default     = "REDIS_6_X"
}

variable "connect_mode" {
  description = "Connection mode: DIRECT_PEERING or PRIVATE_SERVICE_ACCESS"
  type        = string
  default     = "DIRECT_PEERING"
}

variable "transit_encryption_mode" {
  description = "TRANSIT_ENCRYPTION_MODE_DISABLED or ENABLED"
  type        = string
  default     = "DISABLED"
}

variable "read_replicas_mode" {
  description = "DISABLED or READ_REPLICAS_ENABLED (Redis 7 only)"
  type        = string
  default     = "DISABLED"
}

variable "labels" {
  description = "Key-value pairs of labels"
  type        = map(string)
  default     = {}
}

variable "persistence_config" {
  description = "Persistence config (optional)"
  type = object({
    persistence_mode        = string
    rdb_snapshot_period     = string
    rdb_snapshot_start_time = string
  })
  default = null
}

variable "maintenance_policy" {
  description = "Weekly maintenance policy (optional)"
  type = object({
    day     = string
    hours   = number
    minutes = number
    seconds = number
  })
  default = null
}

variable "timeouts" {
  description = "Timeout settings for create/update/delete"
  type = object({
    create = string
    update = string
    delete = string
  })
  default = {
    create = "20m"
    update = "20m"
    delete = "20m"
  }
}


variable "deployment_mode" {
  description = "Redis deployment type: instance or cluster."
  type        = string
  default     = "instance"

  validation {
    condition     = contains(["instance", "cluster"], var.deployment_mode)
    error_message = "deployment_mode must be instance or cluster."
  }
}

# Redis Cluster sizing
variable "cluster_shard_count" {
  description = "Number of shards for Redis Cluster."
  type        = number
  default     = 3

  validation {
    condition     = var.cluster_shard_count >= 1
    error_message = "cluster_shard_count must be at least 1."
  }
}

variable "cluster_replica_count" {
  description = "Number of replicas per shard. Use at least 1 for HA."
  type        = number
  default     = 1

  validation {
    condition     = var.cluster_replica_count >= 0 && var.cluster_replica_count <= 5
    error_message = "cluster_replica_count must be between 0 and 5."
  }
}

variable "cluster_node_type" {
  description = "Redis Cluster node type."
  type        = string
  default     = "REDIS_HIGHMEM_MEDIUM"

  validation {
    condition = contains([
      "REDIS_SHARED_CORE_NANO",
      "REDIS_HIGHMEM_MEDIUM",
      "REDIS_HIGHCPU_MEDIUM",
      "REDIS_STANDARD_LARGE",
      "REDIS_HIGHMEM_XLARGE",
      "REDIS_HIGHMEM_2XLARGE",
      "REDIS_STANDARD_SMALL"
    ], var.cluster_node_type)
    error_message = "Unsupported Redis Cluster node type."
  }
}

variable "cluster_multi_zone" {
  description = "Distribute Redis Cluster nodes across multiple zones."
  type        = bool
  default     = true
}

variable "cluster_network" {
  description = "VPC self-link or resource ID used by Redis Cluster PSC."
  type        = string
  default     = null
  nullable    = true
}

variable "cluster_psc_subnetworks" {
  description = "Existing subnet self-links/IDs used by the PSC service connection policy."
  type        = list(string)
  default     = []
}

variable "cluster_create_service_connection_policy" {
  description = "Create a PSC service connection policy for the Redis Cluster."
  type        = bool
  default     = true
}

variable "cluster_service_connection_policy_name" {
  description = "Name of the PSC service connection policy."
  type        = string
  default     = "redis-cluster-psc-policy"
}

variable "cluster_psc_connection_limit" {
  description = "Optional maximum PSC connections for the service connection policy."
  type        = number
  default     = 2
  nullable    = true
}

variable "cluster_kms_key" {
  description = "Optional full Cloud KMS key resource name for Redis Cluster CMEK."
  type        = string
  default     = null
  nullable    = true
}

variable "cluster_transit_encryption_mode" {
  description = "Redis Cluster TLS mode."
  type        = string
  default     = "TRANSIT_ENCRYPTION_MODE_SERVER_AUTHENTICATION"

  validation {
    condition = contains([
      "TRANSIT_ENCRYPTION_MODE_DISABLED",
      "TRANSIT_ENCRYPTION_MODE_SERVER_AUTHENTICATION"
    ], var.cluster_transit_encryption_mode)
    error_message = "Unsupported Redis Cluster transit encryption mode."
  }
}

variable "cluster_authorization_mode" {
  description = "Redis Cluster authentication mode."
  type        = string
  default     = "AUTH_MODE_IAM_AUTH"

  validation {
    condition = contains([
      "AUTH_MODE_DISABLED",
      "AUTH_MODE_IAM_AUTH"
    ], var.cluster_authorization_mode)
    error_message = "Unsupported Redis Cluster authorization mode."
  }
}

variable "cluster_deletion_protection_enabled" {
  description = "Protect Redis Cluster from accidental deletion."
  type        = bool
  default     = true
}

variable "cluster_redis_configs" {
  description = "Redis Cluster engine configuration."
  type        = map(string)
  default     = {}
}

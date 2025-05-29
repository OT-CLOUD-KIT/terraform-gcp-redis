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
    persistence_mode         = string
    rdb_snapshot_period      = string
    rdb_snapshot_start_time  = string
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
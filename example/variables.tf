
variable "name" {
  description = "Name of the Redis instance."
  type        = string
}

variable "region" {
  description = "Region for the Redis instance."
  type        = string
}

variable "tier" {
  description = "Redis service tier."
  type        = string
  default     = "STANDARD_HA"
}

variable "memory_size_gb" {
  description = "Redis memory size in GB."
  type        = number
}

variable "authorized_network" {
  description = "VPC network self-link."
  type        = string
}

variable "redis_version" {
  description = "Redis engine version."
  type        = string
  default     = "REDIS_6_X"
}

variable "connect_mode" {
  description = "Redis connection mode."
  type        = string
  default     = "DIRECT_PEERING"
}

variable "transit_encryption_mode" {
  description = "Redis transit encryption mode."
  type        = string
  default     = "DISABLED"
}

variable "read_replicas_mode" {
  description = "Redis read replicas mode."
  type        = string
  default     = "DISABLED"
}

variable "labels" {
  description = "Labels for the Redis instance."
  type        = map(string)
  default     = {}
}

variable "project" {
  description = "Google Cloud project ID."
  type        = string
}

variable "persistence_config" {
  description = "Optional Redis persistence configuration."
  type = object({
    persistence_mode        = string
    rdb_snapshot_period     = string
    rdb_snapshot_start_time = string
  })
  default = null
}

variable "maintenance_policy" {
  description = "Optional weekly maintenance policy."
  type = object({
    day     = string
    hours   = number
    minutes = number
    seconds = number
  })
  default = null
}

variable "timeouts" {
  description = "Resource operation timeouts."
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

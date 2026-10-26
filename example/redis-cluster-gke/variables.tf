
variable "project" {
  description = "Google Cloud project ID."
  type        = string
}

variable "name" {
  description = "Redis Cluster name."
  type        = string
  default     = "redis-ha-cluster"
}

variable "region" {
  description = "Region for Redis Cluster."
  type        = string
  default     = "us-central1"
}

variable "labels" {
  description = "Labels applied to Redis resources."
  type        = map(string)
  default = {
    env        = "dev"
    managed_by = "terraform"
  }
}

variable "cluster_shard_count" {
  description = "Number of Redis Cluster shards."
  type        = number
  default     = 3
}

variable "cluster_network" {
  description = "Existing VPC network self-link or resource ID."
  type        = string
}

variable "cluster_psc_subnetworks" {
  description = "Existing subnet IDs for the PSC service connection policy."
  type        = list(string)
}

variable "cluster_kms_key" {
  description = "Optional full Cloud KMS key resource name."
  type        = string
  default     = null
  nullable    = true
}

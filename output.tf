
output "id" {
  description = "Redis instance or cluster ID."
  value = (
    var.deployment_mode == "instance"
    ? try(google_redis_instance.inmemory-storage[0].id, null)
    : try(google_redis_cluster.this[0].id, null)
  )
}

output "host" {
  description = "Redis instance IP address. Null in cluster mode."
  value = (
    var.deployment_mode == "instance"
    ? try(google_redis_instance.inmemory-storage[0].host, null)
    : null
  )
}

output "port" {
  description = "Redis instance port. Null in cluster mode."
  value = (
    var.deployment_mode == "instance"
    ? try(google_redis_instance.inmemory-storage[0].port, null)
    : null
  )
}

output "cluster_discovery_endpoint" {
  description = "Redis Cluster discovery endpoint address."
  value       = try(google_redis_cluster.this[0].discovery_endpoints[0].address, null)
}

output "cluster_discovery_port" {
  description = "Redis Cluster discovery endpoint port."
  value       = try(google_redis_cluster.this[0].discovery_endpoints[0].port, null)
}

output "cluster_psc_connections" {
  description = "Redis Cluster PSC connection details."
  value       = try(google_redis_cluster.this[0].psc_connections, [])
}

output "cluster_state" {
  description = "Redis Cluster lifecycle state."
  value       = try(google_redis_cluster.this[0].state, null)
}

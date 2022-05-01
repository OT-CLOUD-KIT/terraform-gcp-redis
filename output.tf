output "id" {
  description = "An identifier for the resource with format"
  value       = google_redis_instance.default.id
}

output "create_time" {
  description = "The time the instance was created in RFC3339 UTC 'Zulu' format, accurate to nanoseconds."
  value       = google_redis_instance.default.create_time
}

output "current_location_id" {
  description = "The current zone where the Redis endpoint is placed"
  value       = google_redis_instance.default.current_location_id
}

output "host_ip" {
  description = "Private IP address of the Redis host"
  value       = google_redis_instance.default.host
}

output "port" {
  description = "Port number of the Redis endpoint."
  value       = google_redis_instance.default.port
}

output "server_ca_certs" {
  description = "List of server CA certificates for the instance."
  value       = var.transit_encryption_mode == "SERVER_AUTHENTICATION" ? google_redis_instance.default.server_ca_certs : null
}

output "read_endpoint" {
  description = "Output only. Hostname or IP address of the exposed readonly Redis endpoint. Standard tier only."
  value       = var.service_tier == "STANDARD_HA" ? google_redis_instance.default.read_endpoint : null
}

output "read_endpoint_port" {
  description = "Output only. The port number of the exposed readonly redis endpoint. Standard tier only."
  value       = var.service_tier == "STANDARD_HA" ? google_redis_instance.default.read_endpoint_port : null
}
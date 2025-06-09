output "id" {
  value       = google_redis_instance.inmemory-storage.id
  description = "Redis instance ID"
}

output "host" {
  value       = google_redis_instance.inmemory-storage.host
  description = "The IP address of the Redis instance"
}

output "port" {
  value       = google_redis_instance.inmemory-storage.port
  description = "The port number of the Redis instance"
}
resource "google_redis_instance" "default" {
  name                    = local.redis_store_name
  memory_size_gb          = var.service_tier == "STANDARD_HA" && var.read_replicas_mode == "READ_REPLICAS_ENABLED" && var.memory_size_gb < 5 ? 5 : var.memory_size_gb
  display_name            = local.redis_store_display_name
  redis_version           = var.redis_version
  tier                    = var.service_tier
  authorized_network      = var.vpc_network
  region                  = var.region == "" ? local.region : var.region
  location_id             = var.primary_zone_id
  alternative_location_id = var.service_tier == "STANDARD_HA" ? var.region == "" && var.alternative_zone_id == "" ? join(",", random_shuffle.zone.result) : var.alternative_zone_id : null
  auth_enabled            = var.auth_enabled
  transit_encryption_mode = var.transit_encryption_mode
  connect_mode            = local.connect_mode
  reserved_ip_range       = local.ip_cidr_range
  replica_count           = var.service_tier == "STANDARD_HA" && var.read_replicas_mode == "READ_REPLICAS_ENABLED" ? var.replica_count : null
  read_replicas_mode      = var.read_replicas_mode
  redis_configs           = var.redis_config_parameters
  labels                  = var.user_labels

  dynamic "maintenance_policy" {
    for_each = var.maintenance_policy != null ? [var.maintenance_policy] : []

    content {
      description = try(maintenance_policy.value.description, null)

      dynamic "weekly_maintenance_window" {
        for_each = try([maintenance_policy.value.weekly_maintenance_window], [])

        content {
          day = try(weekly_maintenance_window.value.day, "DAY_OF_WEEK_UNSPECIFIED")

          dynamic "start_time" {
            for_each = try([weekly_maintenance_window.value.start_time], [])

            content {
              hours   = try(start_time.value.hours, 0)
              minutes = try(start_time.value.minutes, 30)
              seconds = try(start_time.value.seconds, 0)
              nanos   = try(start_time.value.nanos, 0)
            }
          }
        }
      }
    }
  }
  depends_on = [google_project_service.redis_api, random_shuffle.zone]
  timeouts {
    create = var.redis_timeout
    update = var.redis_timeout
    delete = var.redis_timeout
  }
}

resource "google_project_service" "redis_api" {
  service            = "redis.googleapis.com"
  disable_on_destroy = false
}

resource "random_id" "suffix" {
  byte_length = 8
}

resource "random_shuffle" "zone" {
  input        = local.list_without_primary_zone
  result_count = 1
}
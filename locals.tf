locals {
  redis_store_name = (
    var.name != ""
    ?
    format("redis-%s-%s", var.name, random_id.suffix.hex)
    :
    format("redis-%s", random_id.suffix.hex)
  )
  redis_store_display_name = "Redis-generated-by-Terraform-${random_id.suffix.hex}"
  region                   = data.google_client_config.google_client.region

  # Determine connection mode and IP ranges
  connect_mode  = var.use_private_g_services ? "PRIVATE_SERVICE_ACCESS" : "DIRECT_PEERING"
  ip_cidr_range = var.use_private_g_services ? null : var.ip_cidr_range

  all_available_zone           = data.google_compute_zones.available.names
  remove_primay_zone_from_list = tolist([var.primary_zone_id])
  list_with_item_in_front      = distinct(concat(local.remove_primay_zone_from_list, local.all_available_zone))
  list_without_primary_zone    = slice(local.list_with_item_in_front, 1, length(local.list_with_item_in_front))
}
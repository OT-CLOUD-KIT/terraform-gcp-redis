
# ----------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# ----------------------------------------------------------------------------------------------------------------------

variable "vpc_network" {
  description = "A reference (self link) to the VPC network to host the Redis MemoryStore in."
  type        = string
}

variable "primary_zone_id" {
  description = "The zone to launch the redis instance in."
  type        = string
}
variable "use_private_g_services" {
  description = "Whether to use the VPC's PRIVATE_SERVICE_ACCESS connection mode (recommended). Setting this to \"true\" requires your VPC network (as specified in \"var.vpc_network\") to have its private services connection (also refered to as g_services) to be enabled. Setting this to \"false\" will use the VPC's 'DIRECT_PEERING' connection mode and will require \"var.ip_cidr_range\" to be specified. See https://cloud.google.com/memorystore/docs/redis/networking#connection_modes"
  type        = bool
}
# ----------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# ----------------------------------------------------------------------------------------------------------------------

variable "name" {
  description = "An arbitrary name for the redis instance."
  type        = string
  default     = ""
}

variable "alternative_zone_id" {
  description = "The zone to launch alternate redis instance in when \"var.service_tier\" is set to be \"STANDARD_HA\". Options are \"a\" or \"b\" or \"c\" or \"d\" - must not be same as \"var.primary_zone\". Defaults to a zone other than \"var.primary_zone\" if nothing is specified here. See https://cloud.google.com/compute/docs/regions-zones."
  type        = string
  default     = ""
}

variable "memory_size_gb" {
  description = "Size of the redis memorystore in GB."
  type        = number
  default     = 1
}

variable "redis_version" {
  description = "The version of Redis software. See https://cloud.google.com/memorystore/docs/redis/supported-versions#current_versions."
  type        = string
  default     = "REDIS_4_0"
  validation {
    condition     = contains(["REDIS_3_2", "REDIS_4_0", "REDIS_5_0", "REDIS_6_X"], var.redis_version)
    error_message = "GCP memorystore Redis support versions are 'REDIS_3_2' 'REDIS_4_0' 'REDIS_5_0' 'REDIS_6_X'."
  }
}

variable "service_tier" {
  description = "Either \"BASIC\" for standalone or \"STANDARD_HA\" for high-availability. Should provide \"var.alternate_zone_letter\" if the value of this is set to \"STANDARD_HA\"."
  type        = string
  default     = "BASIC"
  validation {
    condition     = contains(["BASIC", "STANDARD_HA"], var.service_tier)
    error_message = "Either \"BASIC\" for standalone or \"STANDARD_HA\" for high-availability."
  }
}

variable "redis_timeout" {
  description = "how long a redis operation is allowed to take before being considered a failure."
  type        = string
  default     = "20m"
}


variable "ip_cidr_range" {
  description = "A /29 IP CIDR block that will be reserved for the Redis MemoryStore. This value will be disregarded if \"var.use_private_g_services\" is set to be 'true'."
  type        = string
  default     = ""
}

variable "auth_enabled" {
  description = "Indicates whether OSS Redis AUTH is enabled for the instance. If set to true AUTH is enabled on the instance. Default value is false meaning AUTH is disabled."
  type        = bool
  default     = false
}

variable "region" {
  type    = string
  default = ""
}
variable "transit_encryption_mode" {
  type    = string
  default = "DISABLED"
  validation {
    condition     = contains(["SERVER_AUTHENTICATION", "DISABLED"], var.transit_encryption_mode)
    error_message = "Valid value for Trasit encryotion mode are \"SERVER_AUTHENTICATION\" or \"DISABLED\" default is \"DISABLED\"."
  }
}

variable "replica_count" {
  description = "The number of replica nodes. The valid range for the Standard Tier with read replicas enabled is [1-5] and defaults to 2."
  type        = number
  default     = 2
  validation {
    condition     = contains(range(1, 6), var.replica_count)
    error_message = "The valid value for replica_count is [1-5] and defaults to 2."
  }
}

variable "read_replicas_mode" {
  description = "value"
  type        = string
  default     = "READ_REPLICAS_DISABLED"
  validation {
    condition     = contains(["READ_REPLICAS_ENABLED", "READ_REPLICAS_DISABLED"], var.read_replicas_mode)
    error_message = "Possible values for read_replicas_mode are \"READ_REPLICAS_DISABLED\" and \"READ_REPLICAS_ENABLED\"."
  }
}

variable "user_labels" {
  type    = map(string)
  default = {}
}

variable "redis_config_parameters" {
  description = "The Redis configuration parameters. See (https://cloud.google.com/memorystore/docs/redis/reference/rest/v1/projects.locations.instances#Instance.FIELDS.redis_configs) for details."
  type        = map(any)
  default     = {}
}

variable "maintenance_policy" {
  description = "(Optional) Maintenance policy for the Redis instance."
  type        = any
  # type = object({
  #   # (Optional) Description of what this policy is for with a max length of 512 characters.
  #   description = optional(string)
  #   weekly_maintenance_window = optional(object({
  #     # (Optional) The day of week that maintenance updates occur. Defaults to "DAY_OF_WEEK_UNSPECIFIED". Possible values are:
  #     # DAY_OF_WEEK_UNSPECIFIED: The day of the week is unspecified.
  #     # MONDAY: Monday
  #     # TUESDAY: Tuesday
  #     # WEDNESDAY: Wednesday
  #     # THURSDAY: Thursday
  #     # FRIDAY: Friday
  #     # SATURDAY: Saturday
  #     # SUNDAY: Sunday Possible values are DAY_OF_WEEK_UNSPECIFIED, MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, and SUNDAY.
  #     day = string
  #     # (Optional) Start time of the window in UTC time.
  #     start_time = object({
  #       # (Optional) Hours of day in 24 hour format. Should be from 0 to 23.
  #       hours = optional(number)
  #       # (Optional) Minutes of hour of day. Must be from 0 to 59.
  #       minutes = optional(number)
  #       # (Optional) Seconds of minutes of the time. Must normally be from 0 to 59. An API may allow the value 60 if it allows leap-seconds.
  #       seconds = optional(number)
  #       # (Optional) Fractions of seconds in nanoseconds. Must be from 0 to 999,999,999.
  #       nanos = optional(number)
  #     })
  #   }))
  # })
  default = null
}
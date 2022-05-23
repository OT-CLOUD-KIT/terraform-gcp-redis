# GCP Memorystore Redis cluster

[![Opstree Solutions][opstree_avatar]][opstree_homepage]<br/>[Opstree Solutions][opstree_homepage] 

  [opstree_homepage]: https://opstree.github.io/
  [opstree_avatar]: https://img.cloudposse.com/200x100/https://www.opstree.com/images/og_image8.jpg
  - This terraform module will create a complete GCP memorystore redis cluster setup.
  - This project is a part of opstree's ot-gcp initiative for terraform modules.

# Overview of GCP Memorystore for Redis
Memorystore for Redis provides a fully-managed service that is powered by the Redis in-memory data store to build application caches that provide sub-millisecond data access.

## Usage

```
terraform {
  required_providers {
    google = {
      version = "~> 4.19.0"
    }
  }
  required_version = "~>1.1.3"
}

# Configure the GCP Provider

provider "google" {
  credentials = file("<service_account_key_json/p12_file")
  project     = "<project-id>"
  region      = "<region>"
}

#Example BASIC tier redis cluster.
module "redis" {
  source      = "../"
  vpc_network = "squadup-vpc"
  primary_zone_id = "us-east1-b"
  auth_enabled = true
}

# Example STANDARD_HA tier redis cluster for high availability
module "redis" {
  source      = "../"
  vpc_network = "squadup-vpc"
  primary_zone_id = "us-east1-b"
  auth_enabled = true
  service_tier = "STANDARD_HA"
  replica_count = 2
  read_replicas_mode = "READ_REPLICAS_ENABLED"
  redis_version = "REDIS_6_X"
}
```

## Inputs

| Name | Description | Type | Default | Required | Supported |
|------|-------------|:----:|---------|:--------:|:---------:|
| vpc_network | A reference (self link) to the VPC network to host the Redis MemoryStore in. | `string` | | yes | |
| primary_zone_id | The zone to launch the redis instance in. | `string` | | yes | |
| use_private_g_services | "Whether to use the VPC's PRIVATE_SERVICE_ACCESS connection mode (recommended). Setting this to \"true\" requires your VPC network (as specified in \"var.vpc_network\") to have its private services connection (also refered to as g_services) to be enabled. Setting this to \"false\" will use the VPC's 'DIRECT_PEERING' connection mode and will require \"var.ip_cidr_range\" to be specified.| `bool`| | yes | |
| name | An arbitrary name for the redis instance. | `string` | "" | no | |
| alternative_zone_id | The zone to launch alternate redis instance in when \"var.service_tier\" is set to be \"STANDARD_HA\".But must not be same as \"var.primary_zone\".| `string` | `""` | no | |
| memory_size_gb | Size of the redis memorystore in GB. If `var.service_tier` is set to `STANDARD_HA` then `var.memory_size_gb` must be greater than `5`  | `number` | `1` | no | |
| redis_version | The version of Redis software. |`string` | `REDIS_4_0`| no | `REDIS_3_2`<br>`REDIS_4_0`<br>`REDIS_5_0`<br>`REDIS_6_X`|
| service_tier | "Either \"BASIC\" for standalone or \"STANDARD_HA\" for high-availability. |`string` | `BASIC` | no | `BASIC`<br>`STANDARD_HA`|
| ip_cidr_range | A /29 IP CIDR block that will be reserved for the Redis MemoryStore. This value will be disregarded if \"var.use_private_g_services\" is set to be 'true'.| `string` | `""` | no | |
| auth_enabled | Indicates whether OSS Redis AUTH is enabled for the instance. If set to true AUTH is enabled on the instance. Default value is false meaning AUTH is disabled. | `bool` | `false` | no | |
| region | The name of the Redis region of the instance. If blank use provider region |`string` | `""`| no | |
| transit_encryption_mode | The TLS mode of the Redis instance, If not provided, TLS is disabled for the instance. |`string` | `DISABLED` | no | `DISABLED`<br>`SERVER_AUTHENTICATION` |
| replica_count | The number of replica nodes. The valid range for the Standard Tier with read replicas enabled is [1-5] and defaults to 2. | `number` | `2` | no | `1..5` |
| read_replicas_mode | Read replica mode. Can only be specified when trying to create the instance. If not set, Memorystore Redis backend will default to READ_REPLICAS_DISABLED. | `string` | `READ_REPLICAS_DISABLED` | no | `READ_REPLICAS_DISABLED`<br>`READ_REPLICAS_ENABLE` |
| redis_config_parameters | The Redis configuration parameters for advance tuning | `map(any)` | `{}` | no | |
| maintenance_policy  | Maintenance policy for an instance. | `any` | `null` | no | |
| user_labels | Resource labels to represent user provided metadata. | `map(string)` | `{}` | no | |
| redis_timeout | how long a redis operation is allowed to take before being considered a failure. | `string` | `20m` | no | |
#

## Outputs

| Name | Description |  
|------|-------------|
| id | An identifier for the resource with format. `projects/{{project}}/locations/{{region}}/instances/{{name}}` |
| create_time | The time the instance was created in RFC3339 UTC 'Zulu' format, accurate to nanoseconds. |
| current_location_id | The current zone where the Redis endpoint is placed. |
| host_ip | Private IP address of the Redis host |
| port | Port number of the Redis endpoint. |
| server_ca_certs | The configuration endpoint to allow host discovery. |
| read_endpoint | Output only. Hostname or IP address of the exposed readonly Redis endpoint. Standard tier only. |
| read_endpoint_port | Output only. The port number of the exposed readonly redis endpoint. Standard tier only. |

#
## Contributors

[![Pawan Chandna][pawan_avatar]][pawan_homepage]<br/>[Pawan Chandna][pawan_homepage]

  [pawan_homepage]: https://gitlab.com/pawan.chandna
  [pawan_avatar]: https://img.cloudposse.com/75x75/https://gitlab.com/uploads/-/system/user/avatar/7777967/avatar.png?width=400

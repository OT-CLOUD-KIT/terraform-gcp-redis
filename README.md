# Terraform GCP Inmemroy Storage Redis

[![Opstree Solutions][opstree_avatar]][opstree_homepage]<br/>[Opstree Solutions][opstree_homepage] 

  [opstree_homepage]: https://opstree.github.io/
  [opstree_avatar]: https://img.cloudposse.com/150x150/https://github.com/opstree.png

This Terraform module provisions a fully managed [Google Cloud Memorystore for Redis] instance. It supports both `BASIC` and `STANDARD_HA` tiers and includes features like configurable persistence, maintenance policies, and encryption modes. The module is highly configurable and supports dynamic configuration blocks.
The Redis instance can be deployed in any supported GCP region and is intended for secure, scalable caching and state storage. Use this module to quickly integrate Redis into your GCP infrastructure with best practices around customization, timeouts, and project/region flexibility.


## Architecture

<img width="600" length="800" alt="Terraform" src="https://github.com/user-attachments/assets/d77a586d-ae1d-46e3-843e-b76d9c36b368">

## Providers

| Name                                              | Version  |
|---------------------------------------------------|----------|
| <a name="provider_gcp"></a> [gcp](#provider\_gcp) | 5.0.0   |

## Usage

```hcl
module "gcp_redis" {
  source = "./module"

  name               = var.name
  region             = var.region
  tier               = var.tier
  memory_size_gb     = var.memory_size_gb
  authorized_network = var.authorized_network

  redis_version           = var.redis_version
  connect_mode            = var.connect_mode
  transit_encryption_mode = var.transit_encryption_mode
  read_replicas_mode      = var.read_replicas_mode
  labels                  = var.labels
  project                 = var.project

  persistence_config   = var.persistence_config
  maintenance_policy   = var.maintenance_policy
  timeouts             = var.timeouts
}

```

## Inputs

| Name | Description | Type | Default | Required | 
|------|-------------|:----:|---------|:--------:|
| **name**  | The name of the Redis instance | string | n/a | yes |
| **region**  | The region to deploy Redis in | string | n/a | yes |
| **project**  | GCP project ID where Redis will be deployed | string | null | yes |
| **tier**  | Service tier: BASIC or STANDARD_HA | string | n/a | yes |
| **memory_size_gb**  | Memory size of the Redis instance in GB | number | n/a | yes |
| **authorized_network**  | Self-link of the VPC network to attach Redis to | string | n/a | yes |
| **redis_version**  | Redis engine version (e.g. REDIS_6_X) | string | "REDIS_6_X" | no |
| **connect_mode**  | Connection method: DIRECT_PEERING or PRIVATE_SERVICE_ACCESS | string | "DIRECT_PEERING" | no |
| **transit_encryption_mode**  | Enable encryption in transit: ENABLED or DISABLED | string | "DISABLED" | no |
| **read_replicas_mode**  | Enable read replicas (Redis 7 only): READ_REPLICAS_ENABLED or DISABLED | string | "DISABLED" | no |
| **labels**  | Labels to assign to the Redis instance | map(string) | {} | no |
| **persistence_config** | Optional persistence config including mode, snapshot period, and start time | object({ }) | null | no |
| **maintenance_policy** | Optional weekly maintenance window configuration | object({ }) | null | no |
| **timeouts**  | Custom timeout values for create, update, and delete actions | object({ }) | "" | no |


## Outputs

| Name                     | Description                                                                |
|--------------------------|----------------------------------------------------------------------------|
| **redis_instance_id**    | Redis instance ID                                                          |
| **redis_host**           | Redis instance IP address                                                  |
| **redis_port**           | Redis instance port number                                                 |
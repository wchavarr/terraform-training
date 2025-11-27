terraform {
  required_providers {
    akamai = {
      source  = "akamai/akamai"
      version = "~> 9.0"
    }
  }
  required_version = ">= 1.12.0"
}

provider "akamai" {
  config {
    client_secret = var.akamai_client_secret
    host          = var.akamai_host
    access_token  = var.akamai_access_token
    client_token  = var.akamai_client_token
    account_key   = var.akamai_account_key
  }
}

# These variables are for TC account.
variable "akamai_client_secret" {}
variable "akamai_host" {}
variable "akamai_access_token" {}
variable "akamai_client_token" {}
variable "akamai_account_key" {}

data "akamai_property_rules_template" "rules" {
  template_file = abspath("${path.module}/property-snippets/main.json")
}

resource "akamai_edge_hostname" "willtf1-akamaized-net" {
  contract_id   = var.contract_id
  group_id      = var.group_id
  ip_behavior   = "IPV4"
  edge_hostname = "willtf1.akamaized.net"
  ttl           = 300
  use_cases = jsonencode([
    {
      "option" : "LIVE",
      "type" : "GLOBAL",
      "useCase" : "Segmented_Media_Mode"
    }
  ])
}

resource "akamai_property" "willtfamdproperty1" {
  name        = "willtfamdproperty1"
  contract_id = var.contract_id
  group_id    = var.group_id
  product_id  = "prd_Adaptive_Media_Delivery"
  hostnames {
    cname_from             = "api-example.akamaized.net"
    cname_to               = akamai_edge_hostname.willtf1-akamaized-net.edge_hostname
    cert_provisioning_type = "CPS_MANAGED"
  }
  hostnames {
    cname_from             = "blog-example.akamaized.net"
    cname_to               = akamai_edge_hostname.willtf1-akamaized-net.edge_hostname
    cert_provisioning_type = "CPS_MANAGED"
  }
  hostnames {
    cname_from             = "cdn-example.akamaized.net"
    cname_to               = akamai_edge_hostname.willtf1-akamaized-net.edge_hostname
    cert_provisioning_type = "CPS_MANAGED"
  }
  hostnames {
    cname_from             = "shop-example.akamaized.net"
    cname_to               = akamai_edge_hostname.willtf1-akamaized-net.edge_hostname
    cert_provisioning_type = "CPS_MANAGED"
  }
  hostnames {
    cname_from             = "www-example.akamaized.net"
    cname_to               = akamai_edge_hostname.willtf1-akamaized-net.edge_hostname
    cert_provisioning_type = "CPS_MANAGED"
  }
  rule_format = "latest"
  rules       = data.akamai_property_rules_template.rules.json
}

# NOTE: Be careful when removing this resource as you can disable traffic
resource "akamai_property_activation" "willtfamdproperty1-staging" {
  property_id                    = akamai_property.willtfamdproperty1.id
  contact                        = ["wchavarr@akamai.com"]
  version                        = var.activate_latest_on_staging ? akamai_property.willtfamdproperty1.latest_version : akamai_property.willtfamdproperty1.staging_version
  network                        = "STAGING"
  note                           = "First version, from locals"
  auto_acknowledge_rule_warnings = false
}

# NOTE: Be careful when removing this resource as you can disable traffic
resource "akamai_property_activation" "willtfamdproperty1-production" {
  property_id                    = akamai_property.willtfamdproperty1.id
  contact                        = ["wchavarr@akamai.com"]
  version                        = var.activate_latest_on_production ? akamai_property.willtfamdproperty1.latest_version : akamai_property.willtfamdproperty1.production_version
  network                        = "PRODUCTION"
  note                           = "First version, from locals"
  auto_acknowledge_rule_warnings = false
}

// first step create cpcode and edge hostname, then create property using those resources, then use property rules builder to create rules for the property, leave part 2 commented until this is done

resource "akamai_cp_code" "willtfcpcodeamd" {
  name        = "willtfcpcodeamd"
  contract_id = "1-5C13O2"
  group_id = data.akamai_group.read_group.id
  product_id  = "prd_Adaptive_Media_Delivery"
 }

 resource "akamai_edge_hostname" "willtfhostname1" {
  product_id    = "prd_Adaptive_Media_Delivery"
  contract_id   = "1-5C13O2"
  group_id = data.akamai_group.read_group.id
  edge_hostname = "willtf1.akamaized.net"
  ip_behavior   = "IPV4"
  ttl           = 300
  use_cases = jsonencode([
    {
      "type" : "GLOBAL",
      "option" : "LIVE",
      "useCase" : "Segmented_Media_Mode"
    }
  ])
 }

// Step 2, trying to use property rules builder to create rules for the property, this part has to be commented until resources above are created

data "akamai_property_rules_builder" "will_default_rule" {
  rules_v2023_01_05 {
    name      = "default"
    is_secure = false
    comments  = <<-EOT
      The behaviors in the default rule apply to all requests for the property hostnames unless another rule overrides these settings.
    EOT
    behavior {
      origin {
        origin_type                   = "CUSTOMER"
        // origin hostname is from a variable to choose between A/B test declared in variables.tf
        hostname = var.ab_test == "A" ? "origin-a.example.com" : "origin-b.example.com"
        forward_host_header           = "ORIGIN_HOSTNAME"
        cache_key_hostname            = "REQUEST_HOST_HEADER"
        compress                      = true
        enable_true_client_ip         = false
        http_port                     = 80
      }
    }
    behavior {
      cp_code {
        value {
          
          id = akamai_cp_code.willtfcpcodeamd.id
          name = akamai_cp_code.willtfcpcodeamd.name
        }
      }
     }
   
    // to add new rules
    behavior{
    client_characteristics {
    country = "UNKNOWN"
    }
    }

    behavior{
    content_characteristics_amd {
      catalog_size = "UNKNOWN"
      content_type = "HD"
      popularity_distribution = "UNKNOWN"
    }
    }

    behavior{
          origin_characteristics {
        authentication_method = "AUTOMATIC"
        authentication_method_title = ""
        country = "UNKNOWN"
      }
    }

    behavior {
      segmented_media_optimization {
        behavior = "ON_DEMAND"
      }
    }

    // finish new rules
    children = [
    #   data.akamai_property_rules_builder.compress_text_content.json
    ]
  }
}

// Your child rule information
# data "akamai_property_rules_builder" "compress_text_content" {
#   rules_v2023_01_05 {
#     name = "Compress Text Content"
#     behavior {
#       gzip_response {
#           behavior = "ALWAYS"
#       }
#     }
#     criterion {
#       content_type {
#         matchOperator      = "IS_ONE_OF"
#         matchWildcard      = true
#         matchCaseSensitive = false
#         values             = ["text/html*", "text/css*", "application/x-javascript*"]
#       }
#     }
#   }
# }

output "my_default_rule" {
  value = data.akamai_property_rules_builder.will_default_rule
} 



# // end of trying to use property rules builder to create rules for the property

// Step 3, create property using the cpcode and edge hostname created above, this part has to be commented until resources above are created

 resource "akamai_property" "willtfpropertyamd" {
  name        = "willtfamdproperty1"
  product_id  = "prd_Adaptive_Media_Delivery"
  contract_id = "1-5C13O2"
  group_id = data.akamai_group.read_group.id
  //changing hostnames with dynamic hostnames from variable
  # hostnames {
  #   cname_from = akamai_edge_hostname.willtfhostname1.edge_hostname
  #   # cname_from = "willtf1.akamaized.net" --- IGNORE ---
  #   cname_to = akamai_edge_hostname.willtfhostname1.edge_hostname
  #   # cname_to   = "willtf1.akamaized.net" --- IGNORE ---
  #   cert_provisioning_type = "CPS_MANAGED"
  # }
// dynamic hostnames block to create multiple hostnames from variable
dynamic "hostnames" {
        for_each = local.app_hostnames
        content {
            cname_from             = hostnames.value
            cname_to               = akamai_edge_hostname.willtfhostname1.edge_hostname
            cert_provisioning_type = "CPS_MANAGED"
        }
    }
// end of dynamic hostnames block

  rules = data.akamai_property_rules_builder.will_default_rule.json  
  rule_format = "latest"
}

resource "akamai_property_activation" "staging_activation" {
     property_id                    = data.akamai_property.read_propertytf.property_id //"prp_12345"
     network                        = "STAGING"
     contact                        = ["wchavarr@akamai.com"]
     note                           = local.notesP
     version                        = "1"
     auto_acknowledge_rule_warnings = true
     timeouts {
       default = "1h"
     }
}

resource "akamai_property_activation" "production_activation" {
     property_id                    = data.akamai_property.read_propertytf.property_id //"prp_12345"
     network                        = "PRODUCTION"
     contact                        = ["wchavarr@akamai.com"]
     note                           = local.notesP
     version                        = "1"
     auto_acknowledge_rule_warnings = true
     timeouts {
       default = "1h"
     }
        depends_on          = [ 
        resource.akamai_property_activation.staging_activation 
    ]
   compliance_record {
     noncompliance_reason_no_production_traffic {
       
     }
  
   }
}
//data.<data source type>.<data source instance>.<instance attribute>

data "akamai_property" "read_property" {
    name = "will-scriptclub"
}

data "akamai_property" "read_propertytf" {
    name = "willtfamdproperty1"
}

output "prod_version" {
    value = data.akamai_property.read_property.production_version
}

data "akamai_group" "read_group" {
    group_name = "Script Club"
    contract_id = "1-5C13O2"
}

output "group_id" {
    value = data.akamai_group.read_group.id
}


#  data "akamai_appsec_configuration" "my_config" {
#     name = "adarcher"
#  }

# output "secinfo" {
#     value = data.akamai_appsec_configuration.my_config
# }


locals {
  notes = "TF-3001/${data.akamai_group.read_group.id}"
}

locals {
  notesP = "First version, from locals"
}

locals {
  app_hostnames = {for domain in var.apps : "${domain}" => "${domain}-example.akamaized.net"}
}

// local variable for DNS hostnames
locals {
  app_dnshostnames = {for domain in var.apps : "${domain}" => "${domain}.examplewilltf.com"}
}
 
output "hostname" {
  value = local.app_hostnames
}

output "hostnamedns" {
  value = local.app_dnshostnames
}




//data.<data source type>.<data source instance>.<instance attribute>

data "akamai_property" "read_property" {
    name = "will-scriptclub"
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







 //step 1, run this part. Part 2 has to be commented while part 1 is run.
 
 data "akamai_appsec_configuration" "config_toclone" {
    name = "adarcher"
 }

output "test" {
  value = data.akamai_appsec_configuration.config_toclone.config_id
}

data "akamai_appsec_security_policy" "will_policytoclone" {
  config_id = data.akamai_appsec_configuration.config_toclone.config_id
}

output "secid" {
    value = data.akamai_appsec_security_policy.will_policytoclone.security_policy_id_list.1
}

resource "akamai_appsec_configuration" "cloned_config" {
 create_from_config_id = data.akamai_appsec_configuration.config_toclone.config_id
 name        = "Williamtfsecconfig"
 description = "This is a cloned configuration"
 contract_id = "1-5C13O2"
 group_id = data.akamai_group.read_group.id
 host_names  = ["will-scriptclub.test.edgekey.net"]
}

// step 2, this part has to be commented while part 1 is run, then uncomment to run.
data "akamai_appsec_configuration" "my_clonewilliam" {
    name = "Williamtfsecconfig"
 }

 output "my_clonewilliamvalue" {
  value = data.akamai_appsec_configuration.my_clonewilliam.config_id
}

resource "akamai_appsec_security_policy" "william_policy" {
  config_id = data.akamai_appsec_configuration.my_clonewilliam.config_id
  default_settings       = true
  security_policy_name   = "willtf-policy"
  security_policy_prefix = "0001" //this is the policy id, on below error and it has to be 4 digits
//  create_from_security_policy_id = data.akamai_appsec_security_policy.will_policytoclone.security_policy_id_list.1
  //Error: Title: Invalid Input Error; Type: https://problems.luna.akamaiapis.net/appsec-configuration/error-types/INVALID-INPUT-ERROR; Detail: Validation failed: policyId: Policy id must be alpha-numeric, size must be between 1 and 4
#    with akamai_appsec_security_policy.william_policy,
# │   on security.tf line 34, in resource "akamai_appsec_security_policy" "william_policy":
# │   34: resource "akamai_appsec_security_policy" "william_policy" {

}







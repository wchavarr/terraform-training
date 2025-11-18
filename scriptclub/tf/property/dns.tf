resource "akamai_dns_record" "my_dns_hostnames" {
  count = length (values(local.app_dnshostnames))
  zone       = "examplewilltf.com"
  recordtype = "CNAME"
  ttl        = 60
  target     = ["examplewilltf.com.edgekey.net"]
  name       = values(local.app_dnshostnames)[count.index]
}

# locals {
#   app_dnshostnames = {for domain in var.apps : "${domain}" => "${domain}-examplewilltf.com"}
# }


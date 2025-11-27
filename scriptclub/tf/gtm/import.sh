terraform init
terraform import akamai_gtm_domain.ednstest "ednstest.akadns.net"
terraform import akamai_gtm_datacenter.Clone__2__of_DC-1 "ednstest.akadns.net:2"
terraform import akamai_gtm_datacenter.DC-1 "ednstest.akadns.net:1"
terraform import akamai_gtm_property.ns "ednstest.akadns.net:ns"
resource "akamai_gtm_datacenter" "Clone__2__of_DC-1" {
  domain                            = akamai_gtm_domain.ednstest.name
  nickname                          = "Clone (2) of DC-1"
  city                              = "Mumbai"
  country                           = "IN"
  latitude                          = 18.96905
  longitude                         = 72.82118
  clone_of                          = 1
  cloud_server_host_header_override = false
  cloud_server_targeting            = false
  depends_on = [
    akamai_gtm_domain.ednstest
  ]
}

resource "akamai_gtm_datacenter" "DC-1" {
  domain                            = akamai_gtm_domain.ednstest.name
  nickname                          = "DC-1"
  city                              = "Mumbai"
  country                           = "IN"
  latitude                          = 18.96905
  longitude                         = 72.82118
  cloud_server_host_header_override = false
  cloud_server_targeting            = false
  depends_on = [
    akamai_gtm_domain.ednstest
  ]
}


resource "akamai_gtm_property" "ns" {
  domain                      = akamai_gtm_domain.ednstest.name
  name                        = "ns"
  type                        = "weighted-round-robin"
  ipv6                        = false
  score_aggregation_type      = "worst"
  stickiness_bonus_percentage = 0
  stickiness_bonus_constant   = 0
  use_computed_targets        = false
  balance_by_download_score   = false
  dynamic_ttl                 = 60
  handout_limit               = 0
  handout_mode                = "normal"
  failover_delay              = 0
  failback_delay              = 0
  ghost_demand_reporting      = false
  traffic_target {
    datacenter_id = akamai_gtm_datacenter.DC-1.datacenter_id
    enabled       = true
    weight        = 50
    servers       = []
    handout_cname = "alphagslb.yesbank.in"
  }
  traffic_target {
    datacenter_id = akamai_gtm_datacenter.Clone__2__of_DC-1.datacenter_id
    enabled       = true
    weight        = 50
    servers       = []
    handout_cname = "bravogslb.yesbank.in"
  }
  depends_on = [
    akamai_gtm_datacenter.DC-1,
    akamai_gtm_datacenter.Clone__2__of_DC-1,
    akamai_gtm_domain.ednstest
  ]
}


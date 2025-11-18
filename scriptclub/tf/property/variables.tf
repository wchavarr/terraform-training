variable "edgerc_path" {
  description = "Path to the .edgerc file"
  type        = string
  default     = "~/.edgerc"
}

variable "config_section" {
  description = "Section in the .edgerc file to use"
  type        = string
  default     = "default"
}


# These variables are for TC account.
variable "akamai_client_secret" {}
variable "akamai_host" {}
variable "akamai_access_token" {}
variable "akamai_client_token" {}
variable "akamai_account_key" {}

variable "ab_test" {
  description = "A/B Test to create"
  type        = string
  default     = "A"
} 

variable "apps" {
  default = [ "www", "api", "blog", "shop", "cdn"]
}


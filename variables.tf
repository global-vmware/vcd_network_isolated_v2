variable "vdc_group_name" {}

variable "vdc_org_name" {}

variable "vdc_edge_name" {}

# Define a map of segments with their configurations
variable "segments" {
  type = map(object({
    gateway         = string
    prefix_length   = number
    dns1            = string
    dns2            = string
    dns_suffix      = string
    pool_ranges     = list(object({
      start_address = string
      end_address   = string
    }))
  }))
}

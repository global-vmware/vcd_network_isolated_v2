terraform {
  required_version = "~> 1.2"

  required_providers {
    vcd = {
      source  = "vmware/vcd"
      version = "~> 3.8"
    }
  }
}

# Create the Datacenter Group data source
data "vcd_vdc_group" "dcgroup" {
  org       = var.vdc_org_name
  name      = var.vdc_group_name
}

# Create the NSX-T Edge Gateway data source
data "vcd_nsxt_edgegateway" "t1" {
  org      = var.vdc_org_name
  owner_id = data.vcd_vdc_group.dcgroup.id
  name     = var.vdc_edge_name
}

resource "vcd_network_isolated_v2" "org_vdc_isolated_network" {
  org             = var.vdc_org_name
  for_each        = var.segments
  name            = each.key
  owner_id        = data.vcd_vdc_group.dcgroup.id

  gateway         = each.value.gateway
  prefix_length   = each.value.prefix_length
  dns1            = each.value.dns1
  dns2            = each.value.dns2
  dns_suffix      = each.value.dns_suffix

  dynamic "static_ip_pool" {
    for_each = each.value.pool_ranges
    content {
      start_address = static_ip_pool.value.start_address
      end_address   = static_ip_pool.value.end_address
    }
  }
}


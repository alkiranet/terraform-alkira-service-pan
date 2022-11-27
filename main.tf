locals {

  segment_id_list = [
    for v in data.alkira_segment.service : v.id
  ]

  filter_zone_segments = var.segment_options[*].segment

}

data "alkira_segment" "service" {
  for_each = toset(var.segments)
  name     = each.key
}

data "alkira_segment" "zone" {
  for_each = toset(local.filter_zone_segments)
  name     = each.key
}

data "alkira_segment" "mgmt" {
  name = var.mgmt_segment
}

resource "alkira_service_pan" "service" {

  # service 
  name                    = var.name
  cxp                     = var.cxp
  segment_ids             = local.segment_id_list
  management_segment_id   = data.alkira_segment.mgmt.id

  # credentials
  pan_username            = var.username
  pan_password            = var.password

  # licensing
  bundle                  = var.license.bundle
  license_type            = var.license.type
  size                    = var.license.size
  version                 = var.license.version

  # registration
  registration_pin_expiry = var.registration_pin.expiry
  registration_pin_id     = var.registration_pin.id
  registration_pin_value  = var.registration_pin.value

  # master key
  master_key_enabled = var.master_key.enabled
  master_key         = var.master_key.value
  master_key_expiry  = var.master_key.expiry

  # panorama
  panorama_device_group   = var.panorama.device_group
  panorama_enabled        = var.panorama.enabled
  panorama_ip_addresses   = var.panorama.ip_addresses
  panorama_template       = var.panorama.template

  # autoscale
  max_instance_count      = var.max_instance_count
  min_instance_count      = var.min_instance_count

  # handle nested schema for instances 
  dynamic "instance" {
    for_each = {
      for o in var.instances : o.name => o
    }

    content {
      name      = instance.value.name
      auth_code = instance.value.auth_code
      auth_key  = instance.value.auth_key
    }

  }

 # handle nested schema for segment options
  dynamic "segment_options" {
    for_each = {
      for o in var.segment_options : o.zone_name => o
    }

    content {
      groups     = segment_options.value.groups
      segment_id = lookup(data.alkira_segment.zone, segment_options.value.segment).id
      zone_name  = segment_options.value.zone_name
    }

  }
}
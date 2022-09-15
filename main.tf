locals {

  segment_id_list = [
    for v in data.alkira_segment.service : v.id
  ]

  filter_zone_segments = var.zones[*].segment

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
  size                    = var.size
  type                    = var.fw_type
  version                 = var.fw_version
  segment_ids             = local.segment_id_list
  management_segment_id   = data.alkira_segment.mgmt.id

  # credentials + licensing
  bundle                  = var.bundle
  pan_username            = var.credential.username
  pan_password            = var.credential.password
  license_type            = var.credential.license_type
  registration_pin_id     = var.registration_pin.id
  registration_pin_value  = var.registration_pin.value
  registration_pin_expiry = var.registration_pin.expiry

  # if using master_key
  master_key_enabled = var.master_key.enabled
  master_key         = var.master_key.value
  master_key_expiry  = var.master_key.expiry

  # panorama configuration
  panorama_enabled        = var.panorama.enabled
  panorama_device_group   = var.panorama.device_group
  panorama_ip_addresses   = var.panorama.ip_addresses
  panorama_template       = var.panorama.template
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

 # handle nested schema for zone-to-group mappings
  dynamic "segment_options" {
    for_each = {
      for o in var.zones : o.name => o
    }

    content {
      zone_name  = segment_options.value.name
      groups     = segment_options.value.groups
      segment_id = lookup(data.alkira_segment.zone, segment_options.value.segment).id
    }

  }
}
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

resource "alkira_credential_pan" "service" {
  name        = var.credential.name
  username    = var.credential.username
  password    = var.credential.password
  license_key = var.credential.license_key
}

resource "alkira_credential_pan_instance" "instance" {

  for_each = {
    for instance in var.instances : instance.name => instance
  }

  name        = each.value.name
  username    = each.value.username
  password    = each.value.password
  license_key = each.value.license_key
  auth_code   = each.value.auth_code
  auth_key    = each.value.auth_key
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
  credential_id           = alkira_credential_pan.service.id
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
      for instance in alkira_credential_pan_instance.instance : instance.name => instance
    }

    content {
      name          = instance.value.name
      credential_id = instance.value.id
    }

  }

 # handle nested schema for zone-to-group mappings
  dynamic "zones_to_groups" {
    for_each = {
      for o in var.zones : o.name => o
    }

    content {
      zone_name  = zones_to_groups.value.name
      groups     = zones_to_groups.value.groups
      segment_id = lookup(data.alkira_segment.zone, zones_to_groups.value.segment).id
    }

  }
}
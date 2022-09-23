variable "name" {
  description = "Service name"
  type        = string
}

variable "cxp" {
  description = "Alkira CXP to provision service in"
  type        = string
}

variable "size" {
  description = "Alkira service size"
  type        = string
  default     = "SMALL"
}

variable "segments" {
  description = "List of segments to associate with the service"
  type        = list(string)
}

variable "mgmt_segment" {
  description = "Management segment"
  type        = string
}

variable "fw_type" {
  description = "VM-Series type"
  type        = string
  default     = "VM-300"
}

variable "fw_version" {
  description = "VM-Series version"
  type        = string
  default     = "9.1.3"
}

variable "max_instance_count" {
  description = "Max number of Panorama instances for auto-scale; defaults to 1 if Panorama is not used"
  type        = number
  default     = 1
}

variable "min_instance_count" {
  description = "Minimum number of Panorama instances for auto-scale; defaults to 0 if Panorama is not used"
  type        = number
  default     = 0
}

variable "bundle" {
  description = "Software image bundle; required if using 'PAY_AS_YOU_GO' license_type"
  type        = string
  default     = "PAN_VM_300_BUNDLE_2"
}

variable "credential" {
  description    = "Service credential values"

  type = object({
    username         = optional(string)
    password         = optional(string)
    license_type     = optional(string)
    license_sub_type = optional(string)
  })
  sensitive  = true
}

variable "registration_pin" {
  description = "Palo Alto auto-registration values for retrieving license entitlements"

  type = object({
    id     = string
    value  = string
    expiry = string
  })
  sensitive  = true
}

variable "master_key" {
  description = <<EOF
  Every firewall and instance of Panorama has a 'master_key' that encrypts all private keys and passwords.
  If auto-scale is configured, the 'master_key' must match between Panorama and all managed firewalls.
  EOF

  type = object({
    enabled = optional(bool)
    value   = optional(string)
    expiry  = optional(string)
  })
  default    = {}
  sensitive  = true
}

variable "panorama" {
  description = "Palo Alto Panorama configuration; required when auto-scale is configured"

  type = object({
    enabled       = optional(string)
    device_group  = optional(string)
    template      = optional(string)
    ip_addresses  = optional(list(string))
  })
  default = {}
}

variable "instances" {
  description = <<EOF
  Palo Alto instance configuration:
    - 'auth_code' is required if using 'BRING_YOUR_OWN' license_type
    - 'auth_key' is required if Panorama is managing firewalls
  EOF

  type = list(object({
    name          = string
    license_key   = string
    auth_code     = optional(string)
    auth_key      = optional(string)
  }))
}

variable "zones" {
  description = "Zone values; maps Alkira segments + groups to VM-Series Firewall Zones"

  type = list(object({
    name     = optional(string)
    groups   = optional(list(string))
    segment  = optional(string)
  }))
  default = []
}
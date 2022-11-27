variable "name" {
  description = "Service name"
  type        = string
}

variable "cxp" {
  description = "CXP to provision service in"
  type        = string
}

variable "size" {
  description = "Service size"
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

variable "license" {
  description    = "Licensing details"

  type = object({
    type     = optional(string, "PAY_AS_YOU_GO")
    bundle   = optional(string, "PAN_VM_300_BUNDLE_2")
    size     = optional(string, "SMALL")
    version  = optional(string, "9.1.3")
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

variable "password" {
  description = "Firewall password"
  type        = string
  sensitive   = true
}

variable "instances" {
  description = <<EOF
  Palo Alto instance configuration:
    - 'auth_code' is required if using 'BRING_YOUR_OWN' license_type
    - 'auth_key' is required if Panorama is managing firewalls
  EOF

  type = list(object({
    name          = string
    auth_code     = optional(string)
    auth_key      = optional(string)
  }))
}

variable "segment_options" {
  description = "Maps Alkira segments + groups to VM-Series Firewall Zones"

  type = list(object({
    groups     = optional(list(string))
    segment    = optional(string)
    zone_name  = optional(string)
  }))
  default = []
}

variable "username" {
  description = "Firewall username"
  type        = string
  default     = "admin"
  sensitive   = true
}
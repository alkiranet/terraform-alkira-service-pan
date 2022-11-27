# Alkira Service PAN - Terraform Module
This module makes it easy to provision Palo Alto VM-Series Firewalls in Alkira.

## Basic Usage
```hcl
module "pan_service" {
  source = "alkiranet/service-pan/alkira"

  name           = "pan-east"
  cxp            = "US-EAST-2"
  segments       = ["business", "management"]
  mgmt_segment   = "management"
  password       = "password"

  license = {
    type  = "PAY_AS_YOU_GO"
  }

  registration_pin = {
    id      = "123456789"
    value   = "123456789"
    expiry  = "2023-02-01"
  }

  instances = [
    {
      name  = "instance1"
    }
  ]

}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_alkira"></a> [alkira](#requirement\_alkira) | >= 0.9.7 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_alkira"></a> [alkira](#provider\_alkira) | >= 0.9.7 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [alkira_service_pan.service](https://registry.terraform.io/providers/alkiranet/alkira/latest/docs/resources/service_pan) | resource |
| [alkira_segment.mgmt](https://registry.terraform.io/providers/alkiranet/alkira/latest/docs/data-sources/segment) | data source |
| [alkira_segment.service](https://registry.terraform.io/providers/alkiranet/alkira/latest/docs/data-sources/segment) | data source |
| [alkira_segment.zone](https://registry.terraform.io/providers/alkiranet/alkira/latest/docs/data-sources/segment) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cxp"></a> [cxp](#input\_cxp) | CXP to provision service in | `string` | n/a | yes |
| <a name="input_instances"></a> [instances](#input\_instances) | Palo Alto instance configuration:<br>    - 'auth\_code' is required if using 'BRING\_YOUR\_OWN' license\_type<br>    - 'auth\_key' is required if Panorama is managing firewalls | <pre>list(object({<br>    name          = string<br>    auth_code     = optional(string)<br>    auth_key      = optional(string)<br>  }))</pre> | n/a | yes |
| <a name="input_license"></a> [license](#input\_license) | Licensing details | <pre>object({<br>    type     = optional(string, "PAY_AS_YOU_GO")<br>    bundle   = optional(string, "PAN_VM_300_BUNDLE_2")<br>    size     = optional(string, "SMALL")<br>    version  = optional(string, "9.1.3")<br>  })</pre> | n/a | yes |
| <a name="input_master_key"></a> [master\_key](#input\_master\_key) | Every firewall and instance of Panorama has a 'master\_key' that encrypts all private keys and passwords.<br>  If auto-scale is configured, the 'master\_key' must match between Panorama and all managed firewalls. | <pre>object({<br>    enabled = optional(bool)<br>    value   = optional(string)<br>    expiry  = optional(string)<br>  })</pre> | `{}` | no |
| <a name="input_max_instance_count"></a> [max\_instance\_count](#input\_max\_instance\_count) | Max number of Panorama instances for auto-scale; defaults to 1 if Panorama is not used | `number` | `1` | no |
| <a name="input_mgmt_segment"></a> [mgmt\_segment](#input\_mgmt\_segment) | Management segment | `string` | n/a | yes |
| <a name="input_min_instance_count"></a> [min\_instance\_count](#input\_min\_instance\_count) | Minimum number of Panorama instances for auto-scale; defaults to 0 if Panorama is not used | `number` | `0` | no |
| <a name="input_name"></a> [name](#input\_name) | Service name | `string` | n/a | yes |
| <a name="input_panorama"></a> [panorama](#input\_panorama) | Palo Alto Panorama configuration; required when auto-scale is configured | <pre>object({<br>    enabled       = optional(string)<br>    device_group  = optional(string)<br>    template      = optional(string)<br>    ip_addresses  = optional(list(string))<br>  })</pre> | `{}` | no |
| <a name="input_password"></a> [password](#input\_password) | Firewall password | `string` | n/a | yes |
| <a name="input_registration_pin"></a> [registration\_pin](#input\_registration\_pin) | Palo Alto auto-registration values for retrieving license entitlements | <pre>object({<br>    id     = string<br>    value  = string<br>    expiry = string<br>  })</pre> | n/a | yes |
| <a name="input_segment_options"></a> [segment\_options](#input\_segment\_options) | Maps Alkira segments + groups to VM-Series Firewall Zones | <pre>list(object({<br>    groups     = optional(list(string))<br>    segment    = optional(string)<br>    zone_name  = optional(string)<br>  }))</pre> | `[]` | no |
| <a name="input_segments"></a> [segments](#input\_segments) | List of segments to associate with the service | `list(string)` | n/a | yes |
| <a name="input_size"></a> [size](#input\_size) | Service size | `string` | `"SMALL"` | no |
| <a name="input_username"></a> [username](#input\_username) | Firewall username | `string` | `"admin"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_service_id"></a> [service\_id](#output\_service\_id) | ID of the service |
<!-- END_TF_DOCS -->
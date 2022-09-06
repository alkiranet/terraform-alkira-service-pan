terraform {
  required_version = ">= 0.14.0"
  experiments      = [module_variable_optional_attrs]

  required_providers {

    alkira = {
      source  = "alkiranet/alkira"
      version = ">= 0.9.4"
    }

  }
}
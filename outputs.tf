output "id" {
  description = "Service id"
  value       = alkira_service_pan.service.id
}

output "cxp" {
  description = "Service cxp"
  value       = alkira_service_pan.service.cxp
}

output "size" {
  description = "Service size"
  value       = alkira_service_pan.service.size
}

output "fw_type" {
  description = "Firewall type"
  value       = alkira_service_pan.service.type
}

output "fw_version" {
  description = "Firewall version"
  value       = alkira_service_pan.service.version
}
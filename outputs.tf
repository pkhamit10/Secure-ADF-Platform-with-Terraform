output "resource_group_name" {
  description = "Name of the ADF platform resource group."
  value       = azurerm_resource_group.platform.name
}

output "resource_group_id" {
  description = "Resource ID of the ADF platform resource group."
  value       = azurerm_resource_group.platform.id
}

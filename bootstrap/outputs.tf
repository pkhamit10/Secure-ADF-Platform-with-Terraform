output "resource_group_name" {
  description = "Resource group containing Terraform state storage."
  value       = azurerm_resource_group.state.name
}

output "storage_account_name" {
  description = "Storage account name for the Terraform backend."
  value       = azurerm_storage_account.state.name
}

output "container_name" {
  description = "Private container name for the Terraform backend."
  value       = azurerm_storage_container.state.name
}

output "principal_object_id" {
  description = "Object ID of the identity granted the bootstrap roles."
  value       = data.azurerm_client_config.current.object_id
}

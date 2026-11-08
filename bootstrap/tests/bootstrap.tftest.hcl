mock_provider "azurerm" {
  mock_data "azurerm_client_config" {
    defaults = {
      object_id = "00000000-0000-0000-0000-000000000001"
    }
  }

  mock_resource "azurerm_resource_group" {
    defaults = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000002/resourceGroups/rg-test-tfstate"
    }
  }

  mock_resource "azurerm_storage_account" {
    defaults = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000002/resourceGroups/rg-test-tfstate/providers/Microsoft.Storage/storageAccounts/testtfstate123"
    }
  }

  mock_resource "azurerm_storage_container" {
    defaults = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000002/resourceGroups/rg-test-tfstate/providers/Microsoft.Storage/storageAccounts/testtfstate123/blobServices/default/containers/tfstate"
    }
  }
}

run "state_backend" {
  command = apply

  variables {
    resource_group_name  = "rg-test-tfstate"
    storage_account_name = "testtfstate123"
  }

  assert {
    condition     = azurerm_storage_account.state.shared_access_key_enabled == false && azurerm_storage_account.state.https_traffic_only_enabled && !azurerm_storage_account.state.allow_nested_items_to_be_public
    error_message = "The state account must disable shared keys and public blobs and require HTTPS."
  }

  assert {
    condition     = azurerm_storage_container.state.container_access_type == "private" && azurerm_storage_container.state.name == "tfstate"
    error_message = "The state container must be private."
  }

  assert {
    condition     = azurerm_role_assignment.state_contributor.role_definition_name == "Contributor" && azurerm_role_assignment.state_contributor.scope == azurerm_resource_group.state.id && azurerm_role_assignment.state_contributor.principal_id == data.azurerm_client_config.current.object_id
    error_message = "The current identity must receive Contributor on the bootstrap resource group."
  }

  assert {
    condition     = azurerm_role_assignment.state_blob_contributor.role_definition_name == "Storage Blob Data Contributor" && azurerm_role_assignment.state_blob_contributor.scope == azurerm_storage_container.state.id && azurerm_role_assignment.state_blob_contributor.principal_id == data.azurerm_client_config.current.object_id
    error_message = "The current identity must receive Storage Blob Data Contributor on the state container."
  }
}

run "reject_invalid_storage_name" {
  command = plan

  variables {
    resource_group_name  = "rg-test-tfstate"
    storage_account_name = "Invalid-Name"
  }

  expect_failures = [var.storage_account_name]
}

run "reject_invalid_container_name" {
  command = plan

  variables {
    resource_group_name  = "rg-test-tfstate"
    storage_account_name = "testtfstate123"
    container_name       = "invalid--container"
  }

  expect_failures = [var.container_name]
}

mock_provider "azurerm" {}

run "platform_resource_group" {
  command = plan

  variables {
    resource_group_name = "rg-test-platform"
    location            = "westeurope"
    tags                = { environment = "test" }
  }

  assert {
    condition     = azurerm_resource_group.platform.name == "rg-test-platform" && azurerm_resource_group.platform.location == "westeurope" && azurerm_resource_group.platform.tags["environment"] == "test"
    error_message = "The platform resource group must use the configured name, location and tags."
  }

  assert {
    condition     = output.resource_group_name == "rg-test-platform"
    error_message = "The platform resource group name must be exposed as an output."
  }
}

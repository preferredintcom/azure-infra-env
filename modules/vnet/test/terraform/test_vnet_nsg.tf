provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "test_rg" {
  name     = "rg-test-vnet-nsg"
  location = "eastus"
}

module "vnet" {
  source              = "../../"
  vnet_name           = "vnet-test-nsg"
  vnet_cidr           = "10.1.0.0/16"
  location            = azurerm_resource_group.test_rg.location
  resource_group_name = azurerm_resource_group.test_rg.name
  subnets = {
    "subnet1" = { cidr = "10.1.1.0/24" }
  }
  enable_nsg = true
  tags       = { test = "nsg" }
}

output "vnet_id" { value = module.vnet.vnet_id }
output "subnet_ids" { value = module.vnet.subnet_ids }
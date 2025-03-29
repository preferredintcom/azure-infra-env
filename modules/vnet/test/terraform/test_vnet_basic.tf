provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "test_rg" {
  name     = "rg-test-vnet-basic"
  location = "eastus"
}

module "vnet" {
  source              = "../../"
  vnet_name           = "vnet-test-basic"
  vnet_cidr           = "10.0.0.0/16"
  location            = azurerm_resource_group.test_rg.location
  resource_group_name = azurerm_resource_group.test_rg.name
  subnets = {
    "subnet1" = { cidr = "10.0.1.0/24" }
    "subnet2" = { cidr = "10.0.2.0/24" }
  }
  enable_nsg = false
  tags       = { test = "basic" }
}

output "vnet_id" { value = module.vnet.vnet_id }
output "subnet_ids" { value = module.vnet.subnet_ids }
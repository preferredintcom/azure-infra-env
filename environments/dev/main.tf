provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-dev-eastus"
  location = "eastus"
  tags     = { environment = "dev", region = "eastus" }
}

module "vnet" {
  source              = "../../modules/vnet"
  vnet_name           = "vnet-dev-eastus"
  vnet_cidr           = "10.0.0.0/16"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnets = {
    "subnet1" = { cidr = "10.0.1.0/24" }
    "subnet2" = { cidr = "10.0.2.0/24" }
  }
  enable_nsg = true
  tags       = { environment = "dev" }
}

# Virtual Machine
resource "azurerm_network_interface" "nic" {
  name                = "nic-dev-vm"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = module.vnet.subnet_ids["subnet1"]
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "vm-dev-eastus"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B1s" # Free-tier eligible
  admin_username      = "adminuser"
  network_interface_ids = [azurerm_network_interface.nic.id]
  admin_password      = "P@ssw0rd1234!" # Use secrets in production
  disable_password_authentication = false
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  tags = { environment = "dev" }
}

# Blob Storage
resource "azurerm_storage_account" "storage" {
  name                     = "stgdeveastus${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = { environment = "dev" }
}

resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

output "vm_name" { value = azurerm_linux_virtual_machine.vm.name }
output "storage_endpoint" { value = azurerm_storage_account.storage.primary_blob_endpoint }
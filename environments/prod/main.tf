provider "azurerm" {
  features {}
 
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-prod-westus"
  location = "westus"
  tags     = { environment = "prod", region = "westus" }
}

module "vnet" {
  source              = "../../modules/vnet"
  vnet_name           = "vnet-prod-westus"
  vnet_cidr           = "10.1.0.0/16"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnets = {
    "subnet1" = { cidr = "10.1.1.0/24" }
    "subnet2" = { cidr = "10.1.2.0/24" }
  }
  enable_nsg = true
  tags       = { environment = "prod" }
}

# Virtual Machine
resource "azurerm_network_interface" "nic" {
  name                = "nic-prod-vm"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = module.vnet.subnet_ids["subnet1"]
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "vm-prod-westus"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B1s"
  admin_username      = "adminuser"
  network_interface_ids = [azurerm_network_interface.nic.id]
  admin_password      = "P@ssw0rd1234!"
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
  tags = { environment = "prod" }
}

# Blob Storage
resource "azurerm_storage_account" "storage" {
  name                     = "stgprodwestus${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = { environment = "prod" }
}

resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

output "vm_name" { value = azurerm_linux_virtual_machine.vm.name }
output "storage_endpoint" { value = azurerm_storage_account.storage.primary_blob_endpoint }
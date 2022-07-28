terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.7.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscriptionID
}

resource "azurerm_resource_group" "rgRef" {
  name     = "RG-MadeByTerraform-JGeorge"
  location = "eastus"

  tags = {
    Owner       = var.Owner
    Environment = var.Enviorment
  }
}

resource "azurerm_virtual_network" "vnRef" {
  name                = "${var.prefix}network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rgRef.location
  resource_group_name = azurerm_resource_group.rgRef.name

  tags = {
    Owner       = var.Owner
    Environment = var.Enviorment
  }
}

resource "azurerm_subnet" "subnet1Ref" {
  name                 = "${var.prefix}subnet1"
  resource_group_name  = azurerm_resource_group.rgRef.name
  virtual_network_name = azurerm_virtual_network.vnRef.name
  address_prefixes     = ["10.0.2.0/24"]

}

resource "azurerm_network_interface" "nInterfaceRef" {
  name                = "${var.prefix}networkInterface"
  location            = azurerm_resource_group.rgRef.location
  resource_group_name = azurerm_resource_group.rgRef.name

  ip_configuration {
    name                          = "${var.prefix}IpConfig"
    subnet_id                     = azurerm_subnet.subnet1Ref.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    Owner       = var.Owner
    Environment = var.Enviorment
  }
}

resource "azurerm_virtual_machine" "vmRef" {
  name                             = "${var.prefix}virtualMachine"
  location                         = azurerm_resource_group.rgRef.location
  resource_group_name              = azurerm_resource_group.rgRef.name
  network_interface_ids            = [azurerm_network_interface.nInterfaceRef.id]
  vm_size                          = "Standard_DS2_v2"
  delete_data_disks_on_termination = true
  delete_os_disk_on_termination    = true

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }

  storage_os_disk {
    name              = "myosdisk1"
    caching           = "readWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "hostname"
    admin_username = var.adminUserName
    admin_password = var.adminUserPassword
  }

  os_profile_windows_config {
  }

  tags = {
    Owner       = var.Owner
    Environment = var.Enviorment
  }

}




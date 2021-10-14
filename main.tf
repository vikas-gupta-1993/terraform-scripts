terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
}

provider "azurerm" {
    features {}
    client_id       = var.client_id
    client_secret   = var.client_secret
    tenant_id       = var.tenant_id
    subscription_id = var.subscription_id
}


resource "azurerm_resource_group" "rg" {
  name     = local.resource_groupe_name
  location = var.resource_location
  tags = {
    "owner" = "vikas"
  }
}

resource "azurerm_virtual_network" "vnet" {
    name                = "${local.resource_prefix}-vnet"
    address_space       = [var.virtual_network_address_space]
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
    name                        = "${local.server_name}-subnet"    
    resource_group_name         = azurerm_resource_group.rg.name
    virtual_network_name        = azurerm_virtual_network.vnet.name
    address_prefixes            = [var.subnet_address_prefix]
}

resource "azurerm_network_security_group" "nsg" {
    name                         = "${local.server_name}-nsg"
    location                     = azurerm_resource_group.rg.location
    resource_group_name          = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_rule" "nsg_rule_rdp" {
    name                        = "RDP Inbound"
    priority                    = 100
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "3389"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
    resource_group_name         = azurerm_resource_group.rg.name
    network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_network_security_rule" "nsg_rule_http_access" {
    name                        = "http 80"
    priority                    = 200
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "80"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
    resource_group_name         = azurerm_resource_group.rg.name
    network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_network_security_rule" "nsg_rule_azure_storage" {
    name                        = "Azure Storage"
    priority                    = 300
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "80"
    source_address_prefix       = "*"
    destination_address_prefix  = "Storage"
    resource_group_name         = azurerm_resource_group.rg.name
    network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_network_interface" "nic" {
  name                = "example-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address            = var.ip
    private_ip_address_allocation = "static"
  }
}

resource "azurerm_windows_virtual_machine" "vm" {
  name                = "${azurerm_resource_group.rg.name}-vm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = var.vm_size
  admin_username      = var.vm_admin_user
  admin_password      = var.vm_admin_pass
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_id = var.vm_image_uri
}
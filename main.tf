terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "5.1.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {}
  subscription_id = var.subscription_id

}

resource "azurerm_resource_group" "september-rg" {
  name     = var.azurerm_resource_group
  location = var.azurerm_location
}


# Create a Virtual Network
resource "azurerm_virtual_network" "september-virtual-network" {
  name                = var.azurerm_virtual_network
  location            = azurerm_resource_group.september-rg.location
  resource_group_name = azurerm_resource_group.september-rg.name
  address_space       = var.vnet_address_space

  tags = var.tags
}

#Create a Subnet
resource "azurerm_subnet" "september-subnet" {
  name                 = var.azurerm_subnet
  resource_group_name  = azurerm_resource_group.september-rg.name
  virtual_network_name = azurerm_virtual_network.september-virtual-network.name
  address_prefixes     = var.azurerm_subnet_address_space

}

# Create a Public IP
resource "azurerm_public_ip" "september-public-ip" {
  name                = var.azurerm_public_ip
  resource_group_name = azurerm_resource_group.september-rg.name
  location            = azurerm_resource_group.september-rg.location
  allocation_method   = var.allocation_method

  tags = var.tags
}

# Create a Network Security Group
resource "azurerm_network_security_group" "september-nsg" {
  name                = var.azurerm_network_security_group
  location            = azurerm_resource_group.september-rg.location
  resource_group_name = azurerm_resource_group.september-rg.name

  #SSH Rule
  security_rule {
    name                       = var.ssh_rule_name
    priority                   = var.ssh_prority
    direction                  = var.rule_direction
    access                     = var.rule_access
    protocol                   = var.rule_protocol
    source_port_range          = var.source_port_range
    destination_port_range     = tostring(var.ssh_port)
    source_address_prefix      = var.source_address_prefix
    destination_address_prefix = var.destination_address_prefix
  }

  #HTTP Rule
  security_rule {
    name                       = var.http_rule_name
    priority                   = var.http_priority
    direction                  = var.rule_direction
    access                     = var.rule_access
    protocol                   = var.rule_protocol
    source_port_range          = var.source_port_range
    destination_port_range     = tostring(var.http_port) # Port 80
    source_address_prefix      = var.source_address_prefix
    destination_address_prefix = var.destination_address_prefix
  }

  tags = var.tags
}

# Create a Network Interface
resource "azurerm_network_interface" "september-network-interface" {
  name                = var.azurerm_network_interface
  location            = azurerm_resource_group.september-rg.location
  resource_group_name = azurerm_resource_group.september-rg.name

  ip_configuration {
    name                          = var.ip_configuration_name
    subnet_id                     = azurerm_subnet.september-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.september-public-ip.id
  }
}

# Create network interface association with NSG
resource "azurerm_network_interface_security_group_association" "september-nic-nsg-association" {
  network_interface_id      = azurerm_network_interface.september-network-interface.id
  network_security_group_id = azurerm_network_security_group.september-nsg.id
}

# Create a Virtual Machine
resource "azurerm_linux_virtual_machine" "september-vm" {
  name                = var.azurerm_linux_virtual_machine
  resource_group_name = azurerm_resource_group.september-rg.name
  location            = azurerm_resource_group.september-rg.location
  size                = var.vm_size
  admin_username      = var.admin_username
  network_interface_ids = [
    azurerm_network_interface.september-network-interface.id
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.ssh_public_key_path)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.os_disk_storage_account_type
  }

  source_image_reference {
    publisher = var.vm_image.publisher
    offer     = var.vm_image.offer
    sku       = var.vm_image.sku
    version   = var.vm_image.version
  }
}

output "vm_public_ip" {
  description = "Public IP address of the VM"
  value       = azurerm_public_ip.september-public-ip.ip_address
}
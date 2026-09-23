variable "subscription_id" {
  description = "My azure subscription ID where resources will be created"
  type        = string
  sensitive   = true
}

variable "azurerm_resource_group" {
  description = "azure resource group name"
  type        = string
  default     = "september-rg"
}

variable "azurerm_location" {
  description = "azure resource group location"
  type        = string
  default     = "SouthAfricaNorth"
}

variable "azurerm_virtual_network" {
  description = "azure virtual network name"
  type        = string
  default     = "september-vnet"
}

variable "vnet_address_space" {
  description = "Address space CIDR block for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "tags" {
  description = "Tags that apply to all resources"
  type        = map(string)
  default = {
    environment = "staging"
  }

}

variable "azurerm_subnet" {
  description = "azure subnet name"
  type        = string
  default     = "september-subnet"
}

variable "azurerm_subnet_address_space" {
  description = "Address space CIDR block for the subnet"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "azurerm_public_ip" {
  description = "azure public ip name"
  type        = string
  default     = "september-public-ip"
}

variable "allocation_method" {
  description = "Allocation method for the public ip address"
  type        = string
  default     = "Static"
}

variable "azurerm_network_security_group" {
  description = "azure network security group name"
  type        = string
  default     = "september-nsg"
}

variable "azurerm_network_interface" {
  description = "azure network interface name"
  type        = string
  default     = "september-nic"
}

variable "ip_configuration_name" {
  description = "azure network interface ip configuration name"
  type        = string
  default     = "september-ip-config"
}

variable "azurerm_linux_virtual_machine" {
  description = "azure linux virtual machine name"
  type        = string
  default     = "september-vm"
}

variable "vm_size" {
  description = "azure linux virtual machine size"
  type        = string
  default     = "Standard_B2ats_v2"
}

variable "admin_username" {
  description = "azure linux virtual machine admin username"
  type        = string
  default     = "septemberuser"
}

variable "ssh_public_key_path" {
  description = "path to the SSH public key file"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "os_disk_storage_account_type" {
  description = "storage account type for the OS disk"
  type        = string
  default     = "Standard_LRS"
}

variable "vm_image" {
  description = "Source image configuration for the VM"
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default = {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }
}

# Security Rules
variable "rule_direction" {
  description = "Direction of the rule (Inbound or Outbound)"
  type        = string
  default     = "Inbound"
}

variable "rule_access" {
  description = "Access type (Allow or Deny)"
  type        = string
  default     = "Allow"
}

variable "rule_protocol" {
  description = "Protocol for the rule (Tcp, Udp, or *)"
  type        = string
  default     = "Tcp"
}

variable "source_port_range" {
  description = "source port range (use * for all)"
  type        = string
  default     = "*"
}

variable "source_address_prefix" {
  description = "source IP address prefix (use * for all)"
  type        = string
  default     = "*"
}

variable "destination_address_prefix" {
  description = "destination IP address prefix (use '*' for all)"
  type        = string
  default     = "*"
}

# SSH Rule
variable "ssh_rule_name" {
  description = "Name of the SSH inbound rule"
  type        = string
  default     = "Allow-SSH"
}

variable "ssh_prority" {
  description = "priority of the SSH rule (lower is higher priority)"
  type        = number
  default     = 100
}

variable "ssh_port" {
  description = "port number for SSH"
  type        = number
  default     = 22
}

variable "http_rule_name" {
  description = "Name of the HTTP inbound rule"
  type        = string
  default     = "Allow-HTTP"
}

variable "http_priority" {
  description = "priority of the HTTP rule (lower is higher priority)"
  type        = number
  default     = 101
}

variable "http_port" {
  description = "port number for HTTP"
  type        = number
  default     = 80
}


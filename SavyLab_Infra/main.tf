// main config file for VM creation and output of public IP addresses

variable "location" {}
variable "resource_group_name" {}
variable "vnet_address_space" {}
variable "subnet_address_prefix" {}
variable "vm_username" {}
variable "vm_password" {}

provider "azurerm" {
  features {}
}

resource "azurerm_virtual_machine" "vm" {
  name                  = "sl-vm"
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.nic.id]
  vm_size               = "Standard_F2"

  storage_image_reference {
    id = azurerm_image.image.id
  }

  storage_os_disk {
    name              = "myOsDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "sl-vm"
    admin_username = var.vm_username
    admin_password = var.vm_password
  }

  os_profile_windows_config {
    enable_automatic_upgrades = false
    timezone                  = "Eastern Standard Time"
  }

  delete_os_disk_on_termination = true
  depends_on                    = [azurerm_image.image]
}

output "gateway_public_ip_address" {
  value = azurerm_public_ip.public_ip_gateway.ip_address
}

output "server_public_ip_address" {
  value = azurerm_public_ip.public_ip_server.ip_address
}
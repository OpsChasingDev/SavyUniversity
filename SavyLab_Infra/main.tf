variable "location" {}
variable "resource_group_name" {}
variable "vnet_address_space" {}
variable "subnet_address_prefix" {}
variable "vm_username" {}
variable "vm_password" {}

provider "azurerm" {
  features {}
}

resource "azurerm_virtual_network" "vnet" {
  name                = "sl-vnet"
  address_space       = var.vnet_address_space
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "subnet" {
  name                 = "sl-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet_address_prefix
}

resource "azurerm_public_ip" "public_ip_gateway" {
  name                = "sl-public-ip-gateway"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_public_ip" "public_ip_server" {
  name                = "sl-public-ip-server"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_nat_gateway" "nat_gateway" {
  name                = "sl-nat-gateway"
  location            = var.location
  resource_group_name = var.resource_group_name
  depends_on          = [azurerm_subnet.subnet]
}

resource "azurerm_subnet_nat_gateway_association" "subnet_nat_gateway_association" {
  subnet_id      = azurerm_subnet.subnet.id
  nat_gateway_id = azurerm_nat_gateway.nat_gateway.id
}

resource "azurerm_network_security_group" "network_security_group" {
  name                = "sl-network-security-group"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "RDP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "WinRM"
    priority                   = 105
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5985"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "SSH"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_nat_gateway_public_ip_association" "public_ip_association" {
  nat_gateway_id       = azurerm_nat_gateway.nat_gateway.id
  public_ip_address_id = azurerm_public_ip.public_ip_gateway.id
  depends_on           = [azurerm_nat_gateway.nat_gateway]
}

resource "azurerm_subnet_network_security_group_association" "subnet_nsg_association" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.network_security_group.id
  depends_on                = [azurerm_network_security_group.network_security_group]
}

resource "azurerm_network_interface" "nic" {
  name                = "sl-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "nicconfig"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip_server.id
  }
}

resource "azurerm_image" "image" {
  name                = "sl-image"
  location            = var.location
  resource_group_name = var.resource_group_name
  os_disk {
    os_type  = "Windows"
    os_state = "Generalized"
    blob_uri = "https://savyunistorage.blob.core.windows.net/vhd/Server2019Core-v1.vhd"
    size_gb  = 30
  }
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

resource "null_resource" "ansible_dynamic_inventory" {
  depends_on = [azurerm_public_ip.public_ip_server]

  provisioner "local-exec" {
    command = "sed -i '2s/.*/${azurerm_public_ip.public_ip_server.ip_address}/' hosts"
  }
}

resource "time_sleep" "ansible_delay" {
  depends_on = [azurerm_virtual_machine.vm]

  create_duration = "30s"
}

resource "null_resource" "ansible" {
  depends_on = [time_sleep.ansible_delay]

  provisioner "local-exec" {
    command = "ansible-playbook -i hosts playbook.yaml"
  }
}
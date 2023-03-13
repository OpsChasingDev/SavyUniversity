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

resource "azurerm_windows_virtual_machine" "vm" {
  name                  = "sl-vm"
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.nic.id]
  size                  = "Standard_F2"
  admin_username        = var.vm_username
  admin_password        = var.vm_password

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}

output "gateway_public_ip_address" {
  value = azurerm_public_ip.public_ip_gateway.ip_address
}

output "server_public_ip_address" {
  value = azurerm_public_ip.public_ip_server.ip_address
}

resource "null_resource" "open_WinRM" {
  depends_on = [azurerm_windows_virtual_machine.vm]

  provisioner "remote-exec" {
    inline = [
      "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force",
      "Enable-PSRemoting -SkipNetworkProfileCheck -Force",
      "Set-Item -Path WSMan:\\localhost\\Service\\AllowUnencrypted -Value true",
      "Set-NetFirewallRule -DisplayName 'Windows Remote Management (HTTP-In)' -RemoteAddress Internet",
      "Set-Item wsman:\\localhost\\Client\\TrustedHosts -value * -Force"
    ]

    connection {
      type     = "winrm"
      user     = var.vm_username
      password = var.vm_password
      host     = azurerm_public_ip.public_ip_server.ip_address
      insecure = true
      timeout  = "1m"
      port     = 5985
    }
  }
}

resource "null_resource" "ansible" {
  depends_on = [azurerm_windows_virtual_machine.vm]

  provisioner "local-exec" {
    command = "ansible-playbook -i '${azurerm_public_ip.public_ip_server.ip_address},' playbook.yaml"
  }
}
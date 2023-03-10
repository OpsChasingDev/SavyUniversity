variable "location" {
  type    = string
  default = "East US"
}

variable "resource_group_name" {
  type    = string
  default = "Savy_University"
}

provider "azurerm" {
  features {}
}

resource "azurerm_virtual_network" "vnet" {
  name                = "sl-vnet"
  address_space       = ["10.250.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "subnet" {
  name                 = "sl-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.250.1.0/24"]
}

resource "azurerm_public_ip" "public_ip" {
  name                = "sl-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
}

resource "azurerm_nat_gateway" "nat_gateway" {
  name                = "sl-nat-gateway"
  location            = var.location
  resource_group_name = var.resource_group_name
  public_ip_address_id = azurerm_public_ip.public_ip.id
  subnet_id           = azurerm_subnet.subnet.id
  depends_on          = [azurerm_subnet.subnet]
}

resource "azurerm_subnet_network_security_group_association" "subnet_nsg_association" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_nat_gateway.nat_gateway.network_security_group_id
}


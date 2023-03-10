# using terraform.tfvars file in the same directory for passing the values

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

#FIXME: unexpected arguments "public_ip_address_id" and "subnet_id"
# possible fix: azurerm_nat_gateway_public_ip_association
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/nat_gateway_public_ip_association
resource "azurerm_nat_gateway" "nat_gateway" {
  name                = "sl-nat-gateway"
  location            = var.location
  resource_group_name = var.resource_group_name
  depends_on          = [azurerm_subnet.subnet]
}

#FIXME: need azurerm_network_security_group
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group


resource "azurerm_nat_gateway_public_ip_association" "public_ip_association" {
  nat_gateway_id       = azurerm_nat_gateway.nat_gateway.id
  public_ip_address_id = azurerm_public_ip.public_ip.id
  depends_on          = [azurerm_nat_gateway.nat_gateway]
}

resource "azurerm_subnet_network_security_group_association" "subnet_nsg_association" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_nat_gateway.nat_gateway.network_security_group_id
}

output "public_ip_address" {
  value = azurerm_public_ip.public_ip.ip_address
}
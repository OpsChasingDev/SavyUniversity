// creates all dependencies for the VM

data "azurerm_subnet" "subnet" {
  name                 = var.existing_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.existing_vnet_name
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
  depends_on          = [data.azurerm_subnet.subnet]
}

resource "azurerm_subnet_nat_gateway_association" "subnet_nat_gateway_association" {
  subnet_id      = data.azurerm_subnet.subnet.id
  nat_gateway_id = azurerm_nat_gateway.nat_gateway.id
}

resource "azurerm_nat_gateway_public_ip_association" "public_ip_association" {
  nat_gateway_id       = azurerm_nat_gateway.nat_gateway.id
  public_ip_address_id = azurerm_public_ip.public_ip_gateway.id
  depends_on           = [azurerm_nat_gateway.nat_gateway]
}

resource "azurerm_network_interface" "nic" {
  name                = "sl-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "nicconfig"
    subnet_id                     = data.azurerm_subnet.subnet.id
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
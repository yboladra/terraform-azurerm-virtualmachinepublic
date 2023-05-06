# Create Virtual Network
resource "azurerm_virtual_network" "sunvnet" {
  name                = "sunvnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.sunrg.location
  resource_group_name = azurerm_resource_group.sunrg.name
}


# Create Subnet
resource "azurerm_subnet" "mysubnet" {
  name                 = "mysubnet-1"
  resource_group_name  = azurerm_resource_group.sunrg.name
  virtual_network_name = azurerm_virtual_network.sunvnet.name
  address_prefixes     = ["10.0.2.0/24"]
}


# Create Public IP Address for windows server
resource "azurerm_public_ip" "mypublicip" {
  #count = 3
  #name                = "mypublicip-${count.index}"
  name                = "mypublicip"
  resource_group_name = azurerm_resource_group.sunrg.name
  location            = azurerm_resource_group.sunrg.location
  allocation_method   = "Static"
  #domain_name_label = "app1-vm-${random_string.myrandom.id}"
  tags = {
    environment = "Non-prod"
  }
}




#Create network security group
resource "azurerm_network_security_group" "sunnsg01" {
  name                = "Sunnsg01"
  location            = azurerm_resource_group.sunrg.location
  resource_group_name = azurerm_resource_group.sunrg.name

  security_rule {
    name                       = "RDP"
    priority                   = 500
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Production"
  }
}
#azurerm_network_interface_security_group_association
resource "azurerm_network_interface_security_group_association" "sunnsgassociate" {
  network_interface_id      = azurerm_network_interface.winvmnic.id
  network_security_group_id = azurerm_network_security_group.sunnsg01.id
}

# Create Network Interface for Windows server
resource "azurerm_network_interface" "winvmnic" {
  name                          = "winvmnic"
  location                      = azurerm_resource_group.sunrg.location
  resource_group_name           = azurerm_resource_group.sunrg.name
  enable_accelerated_networking = true

  ip_configuration {
    name                          = "internal1"
    subnet_id                     = azurerm_subnet.mysubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.mypublicip.id

  }
}

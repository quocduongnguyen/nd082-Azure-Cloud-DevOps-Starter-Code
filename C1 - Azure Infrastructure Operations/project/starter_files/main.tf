provider "azurerm" {
  features {}
}

resource "azurerm_network_security_group" "main" {
  name                = "${var.prefix}-nsg"
  location            = var.location
  resource_group_name = "${var.prefix}-rg"

  security_rule {
    name                       = "DenyInbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "Internet"
    destination_address_prefix = "VirtualNetwork"
  }

    security_rule {
    name                       = "AllowVnet"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }

  tags = {
    requiretag = "Require tag"
  }
}

resource "azurerm_network_interface" "main" {
  count               = "${var.NumberOfVM > 1 && var.NumberOfVM < 6 ? var.NumberOfVM : 2}"
  name                = "${var.prefix}-nic${count.index}"
  resource_group_name = "${var.prefix}-rg"
  location            = var.location

  ip_configuration {
    name                          = "internal${count.index}"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    requiretag = "Require tag"
  }
}

resource "azurerm_public_ip" "main" {
  name                = "${var.prefix}-public-ip"
  resource_group_name = "${var.prefix}-rg"
  location            = var.location
  allocation_method   = "Static"

  tags = {
    requiretag = "Require tag"
  }
}

resource "azurerm_lb" "main" {
  name                = "${var.prefix}-lb"
  resource_group_name = "${var.prefix}-rg"
  location            = var.location

  frontend_ip_configuration {
    name                 = "${var.prefix}-PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.main.id
  }

  tags = {
    requiretag = "Require tag"
  }
}

resource "azurerm_lb_backend_address_pool" "main" {
  loadbalancer_id = azurerm_lb.main.id
  name            = "${var.prefix}-acctestpool"
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/22"]
  location            = var.location
  resource_group_name = "${var.prefix}-rg"

  tags = {
    requiretag = "Require tag"
  }
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = "${var.prefix}-rg"
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface_backend_address_pool_association" "main" {
  count = "${var.NumberOfVM > 1 && var.NumberOfVM < 6 ? var.NumberOfVM : 2}"
  network_interface_id    = azurerm_network_interface.main[count.index].id
  ip_configuration_name   = "internal${count.index}"
  backend_address_pool_id = azurerm_lb_backend_address_pool.main.id
}

resource "azurerm_availability_set" "main" {
  name                = "${var.prefix}-aset"
  location            = var.location
  resource_group_name = "${var.prefix}-rg"

  tags = {
    requiretag = "Require tag"
  }
}

data "azurerm_image" "main" {
  name                = "myPackerImage"
  resource_group_name = "${var.prefix}-rg"
}

output "image_id" {
  value = "/subscriptions/de14da4d-9ece-4b39-999b-eb57d857a39b/resourceGroups/duongnq9-project1-devops-rg/providers/Microsoft.Compute/images/myPackerImage"
}

resource "azurerm_virtual_machine" "main" {
  count                           = "${var.NumberOfVM > 1 && var.NumberOfVM < 6 ? var.NumberOfVM : 2}"
  name                            = "${var.prefix}-vm${count.index}"
  resource_group_name             = "${var.prefix}-rg"
  location                        = var.location
  vm_size                         = "Standard_D2s_v3"
  network_interface_ids = [
    azurerm_network_interface.main[count.index].id,
  ]

  storage_image_reference {
    id = "${data.azurerm_image.main.id}"
  }

  storage_os_disk {
    managed_disk_type = "Standard_LRS"
    create_option     = "FromImage"
    caching           = "ReadWrite"
     name             = "myosdisk${count.index}"
  }

  os_profile {
    computer_name  = "hostname${count.index}"
    admin_username = "${var.username}"
    admin_password = "${var.password}"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    requiretag = "Require tag"
  }
}
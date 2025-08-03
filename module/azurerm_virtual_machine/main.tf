data "azurerm_public_ip" "pip" {
  name                = var.public_ip_name
  resource_group_name = var.resource_group_name
}

data "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.resource_group_name
}

resource "azurerm_network_interface" "nic_name" {
  name = var.network_interface_name
resource_group_name = var.resource_group_name
  location = var.location

  ip_configuration {
    public_ip_address_id = data.azurerm_public_ip.pip.id
    name = "internal"
    subnet_id = data.azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm_name" {
  name = var.virtual_machine_name
  computer_name   = var.computer_name
resource_group_name = var.resource_group_name
  location = var.location
  size = var.vm_size
  admin_username = var.admin_username
  admin_password = var.admin_password
network_interface_ids = [azurerm_network_interface.nic_name.id]
disable_password_authentication = false
os_disk {
  caching = "ReadWrite"
  storage_account_type = "Standard_LRS"
}
source_image_reference {
  publisher = var.image_publisher
offer = var.image_offer
version = var.image_version
sku = var.image_sku
}
}

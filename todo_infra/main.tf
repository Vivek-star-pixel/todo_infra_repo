module "resource_group" {
  source              = "../module/azurerm_resource_group"
  resource_group_name = "pondu"
  location            = "east us 2"
}

module "virtual_network" {
  depends_on           = [module.resource_group]
  source               = "../module/azurerm_vnet"
  virtual_network_name = "pondu_vnet"
  resource_group_name  = "pondu"
  location             = "east us 2"
  address_space        = ["10.0.0.0/16"]
}
module "frontend_subnet" {
  depends_on           = [module.resource_group, module.virtual_network]
  source               = "../module/azurerm_subnet"
  subnet_name          = "fe_pondu_subnet"
  virtual_network_name = "pondu_vnet"
  resource_group_name  = "pondu"
  address_prefixes     = ["10.0.1.0/24"]
}
module "backend_subnet" {
  depends_on           = [module.resource_group, module.virtual_network]
  source               = "../module/azurerm_subnet"
  subnet_name          = "be_pondu_subnet"
  virtual_network_name = "pondu_vnet"
  resource_group_name  = "pondu"
  address_prefixes     = ["10.0.2.0/24"]
}

module "frontend_pip" {
  depends_on          = [module.resource_group]
  source              = "../module/azurerm_public_ip"
  public_ip_name      = "fe_pondu_pip"
  resource_group_name = "pondu"
  location            = "east us 2"
  allocation_method   = "Static"
}

module "backend_pip" {
  depends_on          = [module.resource_group]
  source              = "../module/azurerm_public_ip"
  public_ip_name      = "be_pondu_pip"
  resource_group_name = "pondu"
  location            = "east us 2"
  allocation_method   = "Static"
}

module "frontend_vm" {
  depends_on             = [module.resource_group, module.virtual_network, module.frontend_pip, module.frontend_subnet]
  source                 = "../module/azurerm_virtual_machine"
  virtual_machine_name   = "fe_pondu_vm"
  computer_name          = "fevm"
  resource_group_name    = "pondu"
  location               = "east us 2"
  vm_size                = "Standard_B1s"
  admin_username         = "adminpondu"
  admin_password         = "pondu@12345"
  public_ip_name         = "fe_pondu_pip"
  subnet_name            = "fe_pondu_subnet"
  image_publisher        = "canonical"
  image_offer            = "0001-com-ubuntu-server-jammy"
  image_version          = "latest"
  image_sku              = "22_04-lts"
  virtual_network_name   = "pondu_vnet"
  network_interface_name = "fe_pondu_nic"
  # virtual_network_name ="pondu_vnet"
}

module "backend_vm" {
  depends_on             = [module.resource_group, module.virtual_network, module.backend_pip, module.backend_subnet]
  source                 = "../module/azurerm_virtual_machine"
  virtual_machine_name   = "be_pondu_vm"
  computer_name          = "bevm"
  network_interface_name = "pondu_nic"
  public_ip_name         = "be_pondu_pip"
  admin_username         = "adminpondu"
  admin_password         = "pondu@12345"
  resource_group_name    = "pondu"
  location               = "east us 2"
  vm_size                = "Standard_B1s"
  image_publisher        = "canonical"
  image_offer            = "0001-com-ubuntu-server-jammy"
  image_version          = "latest"
  image_sku              = "22_04-lts"
  subnet_name            = "be_pondu_subnet"
  virtual_network_name   = "pondu_vnet"
  # virtual_network_name ="pondu_vnet"
}

module "sql_server" {
  depends_on                   = [module.resource_group]
  source                       = "../module/azurerm_sql_server"
  sql_server_name              = "my-sqlserver0099"
  resource_group_name          = "pondu"
  location                     = "east us 2"
  administrator_login          = "ponduserver"
  administrator_login_password = "pondu@12345"
}

module "sql_database" {
  depends_on          = [module.sql_server, module.resource_group]
  source              = "../module/azurerm_sql_database"
  mssql_database_name = "pondu_database"
  sql_server_name     = "my-sqlserver0099"
  resource_group_name = "pondu"
}

module "key_vault" {
  depends_on          = [module.resource_group]
  source              = "../module/azurerm_key_vault"
  key_vault_name      = "pondu-key"
  resource_group_name = "pondu"
  location            = "east us 2"
}

module "key_vault_secret" {
  depends_on          = [module.resource_group, module.key_vault]
  source              = "../module/azurerm_key_secret"
  secret_name         = "dbuser2"
  secret_value        = "MyStrongPass123"
  key_vault_name      = "pondu-key"
  resource_group_name = "pondu"

}
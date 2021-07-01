# Creación de red para la Infraestructura
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network

resource "azurerm_virtual_network" "myNet" {
    name                = "kubernetesnet"
    address_space       = ["10.0.0.0/16"]
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name

    tags = {
        environment = "kubernetes"
    }
}

# Creación de Subnet: Es la misma para los masters y workers
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet

resource "azurerm_subnet" "mySubnet" {
    name                   = "terraformsubnet"
    resource_group_name    = azurerm_resource_group.rg.name
    virtual_network_name   = azurerm_virtual_network.myNet.name
    address_prefixes       = ["10.0.1.0/24"]
}

# Creacion de NIC para las VMs master: Empiezan como 10.10.1.10, 10.10.1.11, 10.10.1.12 ...
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface

resource "azurerm_network_interface" "myNicMaster" {
  count = length(var.masters)
  name                = "vmnic_m${count.index}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

    ip_configuration {
		name                           = "myipconfigurationm${count.index}"
		subnet_id                      = azurerm_subnet.mySubnet.id 
		private_ip_address_allocation  = "Static"
		private_ip_address             = "10.0.1.${10+count.index}"
		public_ip_address_id           = azurerm_public_ip.myPublicIpM[count.index].id
	}

    tags = {
        environment = "kubernetes"
    }

}

# IP pública para las VMs master: 
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip

resource "azurerm_public_ip" "myPublicIpM" {
  count = length(var.masters)
  name                = "vmip_m${count.index}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
  sku                 = "Basic"

    tags = {
        environment = "kubernetes"
    }

}

# Creacion de NIC para las VMs worker: Empiezan como 10.10.1.20, 10.10.1.21, 10.10.1.22 ...
resource "azurerm_network_interface" "myNicWorker" {
  count = length(var.workers)
  name                = "vmnic_w${count.index}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

    ip_configuration {
		name                           = "myipconfigurationw${count.index}"
		subnet_id                      = azurerm_subnet.mySubnet.id 
		private_ip_address_allocation  = "Static"
		private_ip_address             = "10.0.1.${20+count.index}"
		public_ip_address_id           = azurerm_public_ip.myPublicIpW[count.index].id
	}

    tags = {
        environment = "kubernetes"
    }

}

# IP pública para las VMs worker:
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip

resource "azurerm_public_ip" "myPublicIpW" {
  count = length(var.workers)
  name                = "vmip_w${count.index}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
  sku                 = "Basic"

    tags = {
        environment = "kubernetes"
    }

}

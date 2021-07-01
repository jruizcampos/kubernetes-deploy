# Security group
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group

resource "azurerm_network_security_group" "mySecGroup" {
    name                = "sshtraffic"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    tags = {
        environment = "kubernetes"
    }
}

# Vinculamos el security group al interface de red
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_security_group_association

resource "azurerm_network_interface_security_group_association" "mySecGroupAssociationM" {
	count = length(var.masters)
    network_interface_id      = azurerm_network_interface.myNicMaster[count.index].id
    network_security_group_id = azurerm_network_security_group.mySecGroup.id
}

resource "azurerm_network_interface_security_group_association" "mySecGroupAssociationW" {
	count = length(var.workers)
    network_interface_id      = azurerm_network_interface.myNicWorker[count.index].id
    network_security_group_id = azurerm_network_security_group.mySecGroup.id
}

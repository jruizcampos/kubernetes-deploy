# Creamos una máquina virtual
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine

resource "azurerm_linux_virtual_machine" "VM_Master" {
    count = length(var.masters)
    name                = var.masters[count.index]
    resource_group_name = azurerm_resource_group.rg.name
    location            = azurerm_resource_group.rg.location
    size                = var.vm_size_master
    admin_username      = "adminUsername"
    network_interface_ids = [ azurerm_network_interface.myNicMaster[count.index].id ]
    disable_password_authentication = true

    admin_ssh_key {
        username   = var.ssh_user				# username = "adminUsername"
        public_key = file(var.public_key_path)	# public_key = file("~/.ssh/id_rsa.pub")
    }

    os_disk {
        caching              = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    plan {
        name      = "centos-8-stream-free"
        product   = "centos-8-stream-free"
        publisher = "cognosys"
    }

    source_image_reference {
        publisher = "cognosys"
        offer     = "centos-8-stream-free"
        sku       = "centos-8-stream-free"
        version   = "1.2019.0810"
    }

    boot_diagnostics {
        storage_account_uri = azurerm_storage_account.stAccount.primary_blob_endpoint
    }

    tags = {
        environment = "kubernetes"
    }

}

resource "azurerm_linux_virtual_machine" "VM_Worker" {
    count = length(var.workers)
    name                = var.workers[count.index]
    resource_group_name = azurerm_resource_group.rg.name
    location            = azurerm_resource_group.rg.location
    size                = var.vm_size_worker
    admin_username      = "adminUsername"
    network_interface_ids = [ azurerm_network_interface.myNicWorker[count.index].id ]
    disable_password_authentication = true

    admin_ssh_key {
        username   = var.ssh_user				# username = "adminUsername"
        public_key = file(var.public_key_path)	# public_key = file("~/.ssh/id_rsa.pub")
    }

    os_disk {
        caching              = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    plan {
        name      = "centos-8-stream-free"
        product   = "centos-8-stream-free"
        publisher = "cognosys"
    }

    source_image_reference {
        publisher = "cognosys"
        offer     = "centos-8-stream-free"
        sku       = "centos-8-stream-free"
        version   = "1.2019.0810"
    }

    boot_diagnostics {
        storage_account_uri = azurerm_storage_account.stAccount.primary_blob_endpoint
    }

    tags = {
        environment = "kubernetes"
    }

}

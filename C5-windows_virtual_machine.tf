resource "azurerm_windows_virtual_machine" "winvm" {
  #proximity_placement_group_id = azurerm_proximity_placement_group.PPG01.id
  #availability_set_id          = azurerm_availability_set.AVS01.id
  #availability_set_id = azurerm_availability_set.AVS01.id
  #count = 2
  #name                = "winvm${count.index}"
  name                = "winvm"
  resource_group_name = azurerm_resource_group.sunrg.name
  location            = azurerm_resource_group.sunrg.location
  size                = "Standard_DS1_v2"
  admin_username      = "azureadmin"
  admin_password      = "Admin@123"
  #network_interface_ids = [element(azurerm_network_interface.vmnic[*].id, count.index)]
  network_interface_ids = [azurerm_network_interface.winvmnic.id]

  os_disk {
    name                 = "os_disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
   tags = {
   "Env": "test",
    "location ": "east-us",
     "owner": "Yogesh"
   }
  /*provisioner "file" {
  source = "Winvm/formatdisk.ps1"
  destination = "c:/Data/"
  }
  connection {
    type = "winrm"
    host = self.public_ip_address
    user = 
    password = 
  }*/

  provisioner "remote-exec" {
    
    
        connection {
            # it threw an error for the host
           #Error:  Error: timeout - last error: unknown error Post https://*.*.*.*:5985/wsman: dial tcp **.**.**.**:5985: connectex: A connection attempt failed because the connected party did not properly respond after a period of time, or established connection failed because connected host has failed to respond.
            host        = self.public_ip_address
            type        = "winrm"
            user        = "azureadmin"
            password    = "Admin@123"
            port        = 5985
            https       = true
            timeout     = "5m"
        }
       
  
    inline = [ 
      "sleep 120",
      "ipconfig > C:\tmp/ipconfig.txt",
      "echo first text >> ipconfig.txt",
      "powershell -ExecutionPolicy Unrestricted -File c:/Data/formatdisk.ps1"

    ]
    
  
  }
  
}
  /*boot_diagnostics {
  #enabled = "true"
    storage_uri = "azurerm_storage_account.storageac01sunrgprd01.uri"
  }*/



resource "azurerm_managed_disk" "datadisk" {
  name                 = "datadisk"
  location             = azurerm_resource_group.sunrg.location
  resource_group_name  = azurerm_resource_group.sunrg.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 10
}

resource "azurerm_virtual_machine_data_disk_attachment" "attacheddisk" {
  managed_disk_id    = azurerm_managed_disk.datadisk.id
  virtual_machine_id = azurerm_windows_virtual_machine.winvm.id
  lun                = "10"
  caching            = "ReadWrite"
}



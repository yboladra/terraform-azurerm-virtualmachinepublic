# Resource-1: Azure Resource Group
resource "azurerm_resource_group" "sunrg" {
  name     = "sunrg"
  location = "East US"
  #{terraform import "azurerm_resource_group.sunrg" "/subscriptions/a03496aa-3755-431b-887f-25da84076069/resourceGroups/sungr"}

}






/*

# Create proximity_placement_group
resource "azurerm_proximity_placement_group" "PPG01" {
  name                = "ppg01"
  location            = azurerm_resource_group.sunrg.location
  resource_group_name = azurerm_resource_group.sunrg.name
  tags = {
    environment = "Production"
  }
}


#Create availability_set
resource "azurerm_availability_set" "AVS01" {
  name                         = "avs01"
  location                     = azurerm_resource_group.sunrg.location
  resource_group_name          = azurerm_resource_group.sunrg.name
  proximity_placement_group_id = azurerm_proximity_placement_group.PPG01.id
  tags = {
    environment = "Production"
  }
}

resource "azurerm_log_analytics_workspace" "lawsuneast-us01" {
  name                = "lawsuneast-us01"
  location            = azurerm_resource_group.sunrg.location
  resource_group_name = azurerm_resource_group.sunrg.name
  #sku                 = "PerGB2018"
  #retention_in_days   = 30
}

resource "azurerm_automation_account" "Automationaccsun01" {
  name                = "automationaccsun01"
  location            = azurerm_resource_group.sunrg.location
  resource_group_name = azurerm_resource_group.sunrg.name
  sku_name            = "Basic"

  tags = {
    environment = "development"
  }
}
resource "azurerm_recovery_services_vault" "sunrsv01" {
  name                = "sunrsv01"
  location            = azurerm_resource_group.sunrg.location
  resource_group_name = azurerm_resource_group.sunrg.name
  sku                 = "Standard"
  cross_region_restore_enabled = true

  soft_delete_enabled = true
}
resource "azurerm_backup_policy_vm" "Default_policy" {
  name                = "Default_policy"
  resource_group_name = azurerm_resource_group.sunrg.name
  recovery_vault_name = azurerm_recovery_services_vault.sunrsv01.name

  timezone = "UTC"

  backup {
    frequency = "Daily"
    time      = "23:00"
  }

  retention_daily {
    count = 7
  }

  retention_weekly {
    count    = 30
    weekdays = ["Sunday", "Wednesday", "Friday", "Saturday"]
  }

  retention_monthly {
    count    = 7
    weekdays = ["Sunday", "Wednesday"]
    weeks    = ["First", "Last"]
  }
  /*data "azurerm_virtual_machine" "winvm" {
  name                = "winvm"
  resource_group_name = azurerm_resource_group.sunrg.name
}
}
resource "azurerm_backup_protected_vm" "winvm" {
  resource_group_name = azurerm_resource_group.sunrg.name
  recovery_vault_name = azurerm_recovery_services_vault.sunrsv01.name
  source_vm_id        = azurerm_windows_virtual_machine.winvm.id
  backup_policy_id    = azurerm_backup_policy_vm.Default_policy.id
}

/*retention_yearly {
    count    = 0
    weekdays = ["Sunday"]
    weeks    = ["Last"]
    months   = ["January"]
  }*/

/*resource "azurerm_virtual_machine_extension" "mmaagent" {
  depends_on = [ azurerm_log_analytics_workspace.lawsuneast-us01]
  name                 = "mmaagent"
  #virtual_machine_id   = toset([azurerm_windows_virtual_machine.Winvm[count.index],azurerm_windows_virtual_machine.Winvm[count.index]])
  virtual_machine_id   = [azurerm_windows_virtual_machine.mylinuxvm.id]
  publisher            = "Microsoft.EnterpriseCloud.Monitoring"
  type                 = "MicrosoftMonitoringAgent"
  type_handler_version = "1.0"
  auto_upgrade_minor_version = "true"
  settings = <<SETTINGS
    {
      "workspaceId": "azurerm_log_analytics_workspace.lawsuneast-us01.workspaceId"
    }
SETTINGS
   protected_settings = <<PROTECTED_SETTINGS
   {
      "workspaceKey": "azurerm_log_analytics_workspace.lawsuneast-us01.workspaceKey"
   }
PROTECTED_SETTINGS
}*/

#terraform import azurerm_resource_group.importrg1 //subscriptions/a03496aa-3755-431b-887f-25da84076069/resourceGroups/importrg/importrg

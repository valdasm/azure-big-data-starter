##########################
#
# Calls all the Powershell scripts to deploy and run the solution
#
##########################

Set-ExecutionPolicy -Scope Process -ExecutionPolicy Unrestricted
Login-AzureRmAccount

#Deploy Azure resources
$DeployArmTemplatesScript = $PSScriptRoot + "\1.0-DeployArmTemplates.ps1"

&$DeployArmTemplatesScript

#Populate individual application config files
$PopulateConfigsScript = $PSScriptRoot + "\1.1-PopulateConfigs.ps1"

&$PopulateConfigsScript

#Copy reference data to Azure Blob Storage
$CopyDataToStorageScript = $PSScriptRoot + "\1.2-CopyDataToStorage.ps1"

&$CopyDataToStorageScript



##########################
#
# Steps:	
# 1. Reads parameters and sensitive keys from azuredeploy.parameters.json and output.parameters.json
# 2. Updates individual config files (make sure you have made a copy of XXX.config.sample)
#
#
##########################


Param(
    
    [string] $TemplateParametersFile = '..\1-Resources\azuredeploy.parameters.json',
	[string] $OutputParametersFile = '..\1-Resources\output.parameters.json',
	[string] $SqlServerConfigFile = '..\2-SqlServer\SqlDWDbUp\Azure.config',
	[string] $StreamAnalyticsFolder = '..\6-StreamAnalytics\StreamAnalytics',
	[string] $WebAppConfigFile = '..\7-WebApp\DashboardWebApp\Azure.config',
	[string] $EventHubConfigFile = '..\8-EventApps\CarEventsSenderApp\Azure.config'

)

$TemplateParametersFile = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($PSScriptRoot, $TemplateParametersFile))
$OutputParametersFile = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($PSScriptRoot, $OutputParametersFile))

$TemplateParamsJson = Get-Content -Raw -Path $TemplateParametersFile | ConvertFrom-Json 
$OutputParamsJson = Get-Content -Raw -Path $OutputParametersFile | ConvertFrom-Json 

#######################################
#
#  2-SQL Server
#
# https://blogs.msdn.microsoft.com/sonam_rastogi_blogs/2014/05/14/update-xml-file-using-powershell/
#######################################

#Fetch config values from Template Parameters file
$ServerInstance = $TemplateParamsJson.parameters.sqlServerName.value
$DatabaseName = $TemplateParamsJson.parameters.sqlDWDBName.value
$DatabaseUser = $TemplateParamsJson.parameters.sqlDWDBAdminName.value
$DatabasePassword = $TemplateParamsJson.parameters.sqlDWAdminPassword.value

#Load application XML configuration file
$SqlServerConfigFile = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($PSScriptRoot, $SqlServerConfigFile))
$SqlServerXml = [xml](Get-Content $SqlServerConfigFile)

#Swap values in the XML config
$ServerNode = $SqlServerXml.appSettings.Add | where {$_.key -eq 'ServerInstance'}
$ServerNode.Value = $ServerInstance

$DatabaseNode = $SqlServerXml.appSettings.Add | where {$_.key -eq 'DatabaseName'}
$DatabaseNode.Value = $DatabaseName

$UserNode = $SqlServerXml.appSettings.Add | where {$_.key -eq 'DatabaseUser'}
$UserNode.Value = $DatabaseUser

$PasswordNode = $SqlServerXml.appSettings.Add | where {$_.key -eq 'DatabasePassword'}
$PasswordNode.Value = $DatabasePassword

$SqlServerXml.Save($SqlServerConfigFile)



#######################################
#
#  7-WebApps
#
#######################################


#Fetch config values from Template Parameters and Output files
$ServiceBusQueueName = $TemplateParamsJson.parameters.serviceBusQueueName.value
$ServiceHubConnectionString = $OutputParamsJson.serviceBusConnString.value

#Load application XML configuration file
$WebAppConfigFile = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($PSScriptRoot, $WebAppConfigFile))
$WebAppXml = [xml](Get-Content $WebAppConfigFile)

#Swap values in the XML config
$QueueNameNode = $WebAppXml.appSettings.Add | where {$_.key -eq 'ServiceBusQueueName'}
$QueueNameNode.Value = $ServiceBusQueueName

$BusConnStringNode = $WebAppXml.appSettings.Add | where {$_.key -eq 'ServiceBusConnectionString'}
$BusConnStringNode.Value = $ServiceHubConnectionString

$WebAppXml.Save($WebAppConfigFile)

#######################################
#
#  8-EventApps
#
#######################################


#Fetch config values from Template Parameters and Output files
$EhName = $TemplateParamsJson.parameters.eventHubName.value
$EhConnectionString = $OutputParamsJson.eventHubConnString.value

#Load application XML configuration file
$EventHubConfigFile = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($PSScriptRoot, $EventHubConfigFile))
$EventHubXml = [xml](Get-Content $EventHubConfigFile)

#Swap values in the XML config
$HubNameNode = $EventHubXml.appSettings.Add | where {$_.key -eq 'EventHubName'}
$HubNameNode.Value = $EhName

$HubConnStringNode = $EventHubXml.appSettings.Add | where {$_.key -eq 'EventHubConnectionString'}
$HubConnStringNode.Value = $EhConnectionString

$EventHubXml.Save($EventHubConfigFile)



#######################################
#
#  6-StreamAnalytics
#	Not valid for now, because 
#	- it exposes sensitive parameters in ASA config files and GIT
#	- VS project is not used in deployment. ASA deploys via ARM, executing 0-Initial.ps1
#
#######################################

#Fetch config values from Template Parameters file
#$ServerInstance = $TemplateParamsJson.parameters.sqlServerName.value
#$DatabaseName = $TemplateParamsJson.parameters.sqlDWDBName.value
#$DatabaseUser = $TemplateParamsJson.parameters.sqlDWDBAdminName.value
#$DatabasePassword = $TemplateParamsJson.parameters.sqlDWAdminPassword.value
#$ServiceBusQueueName = $TemplateParamsJson.parameters.serviceBusQueueName.value
#$ServiceBusNamespace = $TemplateParamsJson.parameters.serviceBusNamespaceName.value
#$ServiceHubKey = $OutputParamsJson.ServiceBusKey.value

#$EhName = $TemplateParamsJson.parameters.eventHubName.value
#$EhNamespace = $TemplateParamsJson.parameters.namespaceName.value
#$EhKey = $OutputParamsJson.EventHubKey.value
#$StorageKey = $OutputParamsJson.storageAccountKey.value
#$StorageName = $TemplateParamsJson.parameters.storageAccountName.value

##Populate EventHubInput
#$EventHubInputFile = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($PSScriptRoot, $StreamAnalyticsFolder + "\Inputs\EventHubInput.json"))

#$EventHubInputJson = Get-Content $EventHubInputFile -Raw | ConvertFrom-Json
#$EventHubInputJson.EventHubProperties.EventHubName  = $EhName
#$EventHubInputJson.EventHubProperties.ServiceBusNamespace  = $EhNamespace
#$EventHubInputJson.EventHubProperties.SharedAccessPolicyKey  = $EhKey
#$EventHubInputJson | ConvertTo-Json  | set-content $EventHubInputFile

##Populate ReferenceInput
#$ReferenceInputFile = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($PSScriptRoot, $StreamAnalyticsFolder + "\Inputs\ReferenceInput.json"))

#$ReferenceInputJson = Get-Content $ReferenceInputFile -Raw | ConvertFrom-Json
#$ReferenceInputJson.BlobReferenceProperties.StorageAccounts | % {$_.AccountKey=$StorageKey; $_.AccountName=$StorageName}
#$ReferenceInputJson | ConvertTo-Json  | set-content $ReferenceInputJson
##https://stackoverflow.com/questions/35865272/how-do-i-update-json-file-using-powershell

##Populate SericeBusOutput
#$ServiceBusOutputFile = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($PSScriptRoot, $StreamAnalyticsFolder + "\Outputs\ServiceBusOutput.json"))

#$ServiceBusOutputJson = Get-Content $ServiceBusOutputFile -Raw | ConvertFrom-Json
#$ServiceBusOutputJson.ServiceBusQueueProperties.QueueName  = $ServiceBusQueueName
#$ServiceBusOutputJson.ServiceBusQueueProperties.ServiceBusNamespace  = $ServiceBusNamespace
#$ServiceBusOutputJson.ServiceBusQueueProperties.SharedAccessPolicyKey  = $ServiceHubKey
#$ServiceBusOutputJson | ConvertTo-Json  | set-content $ServiceBusOutputFile

##Populate SqlOutput

#$SqlOutputFile = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($PSScriptRoot, $StreamAnalyticsFolder + "\Outputs\SqlOutput.json"))

#$SqlOutputJson = Get-Content $SqlOutputFile -Raw | ConvertFrom-Json
#$SqlOutputJson.SQLDatabaseProperties.Database  = $DatabaseName
#$SqlOutputJson.SQLDatabaseProperties.Password  = $DatabasePassword
#$SqlOutputJson.SQLDatabaseProperties.Server  = $ServerInstance
#$SqlOutputJson.SQLDatabaseProperties.User  = $DatabaseUser
#$SqlOutputJson | ConvertTo-Json  | set-content $SqlOutputFile
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
$QueueName = $TemplateParamsJson.parameters.serviceBusQueueName.value
$ServiceHubConnectionString = $OutputParamsJson.serviceBusConnString.value

#Load application XML configuration file
$WebAppConfigFile = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($PSScriptRoot, $WebAppConfigFile))
$WebAppXml = [xml](Get-Content $WebAppConfigFile)

#Swap values in the XML config
$QueueNameNode = $WebAppXml.appSettings.Add | where {$_.key -eq 'ServiceBusQueueName'}
$QueueNameNode.Value = $QueueName

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


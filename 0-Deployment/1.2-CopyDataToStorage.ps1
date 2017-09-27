
####################
#
#
# Copy car_info.csv into Azure Blob Storage
#
#
####################

Param(
    
    [string] $TemplateParametersFile = '..\1-Resources\azuredeploy.parameters.json',
	[string] $OutputParametersFile = '..\1-Resources\output.parameters.json',
	[string] $ReferenceDataLocation = '..\1-Resources\Data',
	[string] $ReferenceDataFile = 'car_info.csv'

)

$BlobName = "ReferenceData\"+$ReferenceDataFile;

$TemplateParametersFile = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($PSScriptRoot, $TemplateParametersFile))
$OutputParametersFile = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($PSScriptRoot, $OutputParametersFile))
$ReferenceDataFile = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($PSScriptRoot, $ReferenceDataLocation, $ReferenceDataFile))

$TemplateParamsJson = Get-Content -Raw -Path $TemplateParametersFile | ConvertFrom-Json 
$OutputParamsJson = Get-Content -Raw -Path $OutputParametersFile | ConvertFrom-Json 

$StorageContainerName = $TemplateParamsJson.parameters.storageContainerName.value
$StorageAccountName = $TemplateParamsJson.parameters.storageAccountName.value
$StorageAccountKey = $OutputParamsJson.storageAccountKey.value
$SubscriptionName = $JsonTemplateParam.parameters.subscriptionName.value
$ResourceGroupName = $JsonTemplateParam.parameters.resourcesGroupName.value

Set-StrictMode -Version 3

Login-AzureRmAccount
Select-AzureRmSubscription -SubscriptionName $SubscriptionName

$Storage = Get-AzureRmStorageAccount -Name $StorageAccountName -ResourceGroupName $ResourceGroupName

try
{
    New-AzureStorageContainer -Name $StorageContainerName -Context $Storage.Context -Permission blob    
	Set-AzureStorageBlobContent -File $ReferenceDataFile -Container $StorageContainerName -Blob $BlobName -Context $Storage.Context 
    Write-Host $ReferenceDataFile “is uploaded successfully.”
}
catch
{
	$warningMessage = “Unable to upload file ” + $ReferenceDataFile
	Write-Warning -Message $warningMessage
}
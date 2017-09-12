#Requires -Version 3.0
#Requires -Module AzureRM.Resources
#Requires -Module Azure.Storage
##########################
#
# Steps:	
# 1. Read azuredeploy.json with parameters saved in azuredeploy.parameters.json
# 2. Save output from azuredeploy.json into output.parameters.json
# 
#
##########################

Param(
    [string] $TemplateFile = '..\1-Resources\azuredeploy.json',
    [string] $TemplateParametersFile = '..\1-Resources\azuredeploy.parameters.json',
    [string] $OutputParametersFile = '..\1-Resources\output.parameters.json',
    [switch] $ValidateOnly
)

try {
    [Microsoft.Azure.Common.Authentication.AzureSession]::ClientFactory.AddUserAgent("VSAzureTools-$UI$($host.name)".replace(' ','_'), '3.0.0')
} catch { }

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 3

function Format-ValidationOutput {
    param ($ValidationOutput, [int] $Depth = 0)
    Set-StrictMode -Off
    return @($ValidationOutput | Where-Object { $_ -ne $null } | ForEach-Object { @('  ' * $Depth + ': ' + $_.Message) + @(Format-ValidationOutput @($_.Details) ($Depth + 1)) })
}

$OptionalParameters = New-Object -TypeName Hashtable
$TemplateFile = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($PSScriptRoot, $TemplateFile))
$TemplateParametersFile = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($PSScriptRoot, $TemplateParametersFile))
$OutputParametersFile = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($PSScriptRoot, $OutputParametersFile))

$JsonTemplateParam = Get-Content -Raw -Path $TemplateParametersFile | ConvertFrom-Json 
$SubscriptionName = $JsonTemplateParam.parameters.subscriptionName.value
$ResourceGroupName = $JsonTemplateParam.parameters.resourcesGroupName.value
$ResourceGroupLocation = $JsonTemplateParam.parameters.resourcesGroupLocation.value

Login-AzureRmAccount
Select-AzureRmSubscription -SubscriptionName $SubscriptionName

# Create or update the resource group using the specified template file and template parameters file
New-AzureRmResourceGroup -Name $ResourceGroupName -Location $ResourceGroupLocation -Verbose -Force

if ($ValidateOnly) {
    $ErrorMessages = Format-ValidationOutput (Test-AzureRmResourceGroupDeployment -ResourceGroupName $ResourceGroupName `
                                                                                  -TemplateFile $TemplateFile `
                                                                                  -TemplateParameterFile $TemplateParametersFile `
                                                                                  @OptionalParameters)
    if ($ErrorMessages) {
        Write-Output '', 'Validation returned the following errors:', @($ErrorMessages), '', 'Template is invalid.'
    }
    else {
        Write-Output '', 'Template is valid.'
    }
}
else {
      $GroupDeploymentOutput = (New-AzureRmResourceGroupDeployment -Name ((Get-ChildItem $TemplateFile).BaseName + '-' + ((Get-Date).ToUniversalTime()).ToString('MMdd-HHmm')) `
                                       -ResourceGroupName $ResourceGroupName `
                                       -TemplateFile $TemplateFile `
                                       -TemplateParameterFile $TemplateParametersFile `
                                       @OptionalParameters `
                                       -Force -Verbose `
                                       -ErrorVariable ErrorMessages | Select -Last 1 ).Outputs
    
    Write-Output $GroupDeploymentOutput
    $JsonOutputParam = $GroupDeploymentOutput | ConvertTo-Json | Set-Content $OutputParametersFile


    if ($ErrorMessages) {
        Write-Output '', 'Template deployment returned the following errors:', @(@($ErrorMessages) | ForEach-Object { $_.Exception.Message.TrimEnd("`r`n") })
    }
}



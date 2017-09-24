

1. 1-Resources
1.1 XXX.config.sample -> XXX.config
1.2 Run 0-DeployAll.ps1 (you will be asked to login to your Azure account) (you might need Set-ExecutionPolicy -Scope Process -ExecutionPolicy Unrestricted)
1.3 Deployment might fail because some of the global names are takes e.g. sql server or storage
1.4 Powershell script 1.0-DeployArmTemplates.ps1 saves connection strings to output.parameters.json (added to gitignore)
1.5 Powershell script 1.1-PopulateConfigs.ps1 updates all application configuration files


2-SqlServer
2.1 Go into portal, database, firewall, and add your IP adress; Click Add client IP, and you might reduce by 1 Start IP
2.2 Scripts should be marked as Embedded Resources

3. Data Lake Analytics
3.1 Create AzureAD application - maybe will survive without this since stream analytics need to click authorize anyways
https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-authenticate-service-principal

6-StreamAnalytics
6.1 Stream analytics projects at the moment connot be under folders in a solution, due to some issues with the VS component.
For this reason Stream Analytics hangs at root level
6.2 ARM template for Stream Analytics doesn't support Data Lake store as an output yet. Strange, it's supperted via Portal
6.3 Stream Analytics has tool for VS. Again, there is no support for Data Lake Store output.
	WORKAROUND for both -> Create manually in the portal

10. PowerBI
10.1. PowerBI cloud can be accessed only using company email.




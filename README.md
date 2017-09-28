TODO:
(/) 1. Powershell to copy reference data into BlobStorage
(/) 2. Change Azure SQL into SQL Data Warehouse in deployment template
(/) 3. Validate sql scripts deployment
4. Set AzureStreamAnalytics inputs / outputs / job
5. WebApp Deployment
- Doesn't fetch App.settings in Azure
6. AzureDataFactory - Later
7. DataLakeAnalytics - Later
8. MachineLearning - Later
9. 

1. 1-Resources
- XXX.config.sample -> XXX.config
- Run 0-DeployAll.ps1 (you will be asked to login to your Azure account) (you might need Set-ExecutionPolicy -Scope Process -ExecutionPolicy Unrestricted)
- Deployment might fail because some of the global names are takes e.g. sql server or storage
- Powershell script 1.0-DeployArmTemplates.ps1 saves connection strings to output.parameters.json (added to gitignore)
- Powershell script 1.1-PopulateConfigs.ps1 updates all application configuration files


2-SqlServer
- Go into portal, database, firewall, and add your IP adress; Click Add client IP, and you might reduce by 1 Start IP
- Scripts should be marked as Embedded Resources

3. Data Lake Analytics
- Create AzureAD application - maybe will survive without this since stream analytics need to click authorize anyways
https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-authenticate-service-principal

6-StreamAnalytics
- Stream analytics projects at the moment connot be under folders in a solution, due to some issues with the VS component.
For this reason Stream Analytics hangs at root level
- ARM template for Stream Analytics doesn't support Data Lake store as an output yet. Strange, it's supperted via Portal
- Stream Analytics has tool for VS. Again, there is no support for Data Lake Store output.
	WORKAROUND for both -> Create manually in the portal

10. PowerBI
- PowerBI cloud can be accessed only using company email.




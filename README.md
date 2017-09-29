#Getting Started

This project aims to simplify Azure Big Data environment setup. Involved Azure PaaS services require different development and deployment steps, and this initiative is a set of suggestions for improving the overall development experience. We use car telemetry data as an example. 

You can find more information about Big Data architectural style in Azure [here.](https://docs.microsoft.com/en-us/azure/architecture/guide/architecture-styles/big-data)

Azure offers many different PaaS services for stream and batch workloads. Since HDInsight offerings require extra effort and don't offer multitenancy, this project only focuses on full scope PaaS. Below you find the architecture and involved services. Green dots mark currently utilized services. 


![Silvrback blog image sb_float_center](https://silvrback.s3.amazonaws.com/uploads/63050ce6-d2f8-4e8c-a610-5184abdaac73/Azure%20Big%20Data%20(1).png)


####Structure
0-Deployment - *PowerShell scripts*
1-Resources - *ARM templates and csv telemetry data files*
2-SqlServer - *Incremental database updates for Azure SQL Data Warehouse*
3-DataLakeAnalytics - *Empty*
4-DataFactory - *Empty*
5-MachineLearning - *Empty*
6-StreamAnalytics  - *WIP. Currently Stream Analytics objects are located in 1-Resources*
7-WebApp - *SignalR + Google Map dashboard*
8-EventApps - *Sending telemetry data to Event Hubs*

####Prerequisites
* [Azure Subscription](https://azure.microsoft.com/en-us/free/)
* [Visual Studio 2015](https://www.visualstudio.com/vs/older-downloads/)
* [Azure PowerShell 2](https://docs.microsoft.com/en-us/powershell/azure/overview?view=azurermps-4.4.0)
* [Azure Stream Analytics for VS 2015](https://docs.microsoft.com/en-us/azure/stream-analytics/stream-analytics-tools-for-visual-studio)
* [Azure Data Factory for VS2015](https://marketplace.visualstudio.com/items?itemName=AzureDataFactory.MicrosoftAzureDataFactoryToolsforVisualStudio2015)


#Deployment
####Steps
**1** Find all *XXX.config.sample* files (5) and make a copy and name it *XXX.config*. (XXX.config files are ignored by Git). 

![Silvrback blog image sb_float_center](https://silvrback.s3.amazonaws.com/uploads/7c2cf059-cdda-4a2a-b53a-03ca2a28930b/1-Resources.jpg)

**2** Populate *1-Resources/azuredeploy.parameters.json* with your parameters (use only lower letters for service names and be creative since some require globally unique names)

![Silvrback blog image sb_float_center](https://silvrback.s3.amazonaws.com/uploads/809f97d3-b069-480e-b916-9b69826f61bf/azure-big-data-starter%20-%20Microsoft%20Visual%20Studio_2_medium.jpg)

**3** Run *0-Deployment\0-Initial.ps1* 
- Creates Azure Resources
- Populates local config files afterward
- Uploads reference data for data enrichment

**4** [Go to Azure portal and add your IP to Azure SQL database](https://msftplayground.com/2017/01/adding-your-client-ip-to-the-azure-sql-server-firewall/)

**5** Build and run *2-SqlServer\SqlDWDbUp* project to deploy database objects.
*insert print screen*
 
#Execution
1.Go to Azure portal and run Stream Analytics
2.Run locally  *7-WebApp\DashboardWebApp* to open a dashboard (refresh multiple times if Google map is not visible)
3.Run locally *8-EventApps\CarEventsSenderApp* to send events to event hub.
4.Monitor DashboardWebApp 

5.Connect to [SQL Data Warehouse](https://docs.microsoft.com/en-us/azure/sql-data-warehouse/sql-data-warehouse-query-visual-studio) and query *dbo.CarHealthStatus*

![Silvrback blog image sb_float_center](https://silvrback.s3.amazonaws.com/uploads/3b34f265-9a84-4992-9ade-fa4fc46f6a4b/azure-big-data-starter%20-%20Microsoft%20Visual%20Studio_3_medium.jpg)

#Limitations
* Global names required for some services (in case of deployment failure due to incorrect name, change the name of problematic service and execute once again) 
* Stream Analytics projects cannot be under folders in a solution, due to some issues with the VS component. Due to this limitation Stream Analytics hangs at root level
* ARM template for Stream Analytics doesn't support Data Lake store and PowerBI as outputs. 
* Data Lake Store and required Azure AD App
 

#To Do
* Azure ASA inputs, outputs, and the query is deployed from 1-Resources\azuredeploy.json. Use 6-StreamAnalytics project* Figure out how to deal with sensitive info in ASA config files and GIT
* Start ASA after deployment 
* WebApp deployment to Azure (doesn't fetch values from Azure.config)
* DataLakeAnalytics 
* AzureDataFactory (v2?)
* Machine Learning (v2?)


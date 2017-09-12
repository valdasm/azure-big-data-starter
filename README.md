https://docs.microsoft.com/en-us/azure/architecture/guide/architecture-styles/big-data

# StreamAnalyticsDemo

One Paragraph of project description goes here

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

Visual Studio components...
What things you need to install the software and how to install them

```
Give examples
```

### Installing


1. 1-Resources
1.1 Enter your passwords in 1-Resources/azuredeploy.parameters.json
1.2 
1.2 Run 1-DeployArmTemplates.ps1 (you will be asked to login to your Azure account) (you might need Set-ExecutionPolicy -Scope Process -ExecutionPolicy Unrestricted)
1.2 Deployment might fail because some of the global names are takes e.g. sql server or storage
1.3 Powershell script from 1.2 saves connection strings to output.parameters.json (make sure you don't commit this)


2-SqlServer
2.1 Remember to open firewall ports on sql server
2.2 

6-StreamAnalytics
Stream analytics projects at the moment connot be under folders in a solution, due to some issues with the VS component.
For this reason Stream Analytics hangs at root level

A step by step series of examples that tell you have to get a development env running

Say what the step will be

```
Give the example
```

And repeat

```
until finished
```

End with an example of getting some data out of the system or using it for a little demo

## Running the tests

Explain how to run the automated tests for this system

### Break down into end to end tests

Explain what these tests test and why

```
Give an example
```

### And coding style tests

Explain what these tests test and why

```
Give an example
```

## Deployment

Add additional notes about how to deploy this on a live system

## Built With

* [Dropwizard](http://www.dropwizard.io/1.0.2/docs/) - The web framework used
* [Maven](https://maven.apache.org/) - Dependency Management
* [ROME](https://rometools.github.io/rome/) - Used to generate RSS Feeds

## Contributing

Please read [CONTRIBUTING.md](https://gist.github.com/PurpleBooth/b24679402957c63ec426) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/your/project/tags). 

## Authors

* **Billie Thompson** - *Initial work* - [PurpleBooth](https://github.com/PurpleBooth)

See also the list of [contributors](https://github.com/your/project/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Hat tip to anyone who's code was used
* Inspiration
* etc




# Azure-Patterns-Big-Data

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fvaldasm%2Fazure-patterns-big-data%2Fmaster%2FAzure-Patterns-Big-Data%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>


<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Fvaldasm%2Fazure-patterns-big-data%2Fmaster%2FAzure-Patterns-Big-Data%2Fazuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>

For information about using this template, see [Create a EventHubs namespace with EventHub and ConsumerGroup using an ARM template](http://azure.microsoft.com/documentation/articles/service-bus-resource-manager-namespace-event-hub/).

TODO
1. Output
	1.1. Write-Output $output[1].OutputsString
	1.2. Add DB user name and password to output
2. Create AD for user credential
3. Create Azure Data Factory
4. 

Issues
1. Stream Analytics
1.1. ARM template for Stream Analytics doesn't support Data Lake store as an output yet. Strange, it's supperted via Portal
1.2. Stream Analytics has tool for VS. Again, there is no support for Data Lake Store output.
	WORKAROUND for both -> Create manually in the portal

2. PowerBI
2.1. PowerBI cloud can be accessed only using company email.
4. AzureAD app required to access Lake Storage via Azure Data Factory
No - user credential authentication would be enough here
user credential could be used just via portal
https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-authenticate-service-principal

Lake folders:

Azure DW:
Tables: 
- events_aggregated
- cars
- cars_consumption

1-Resources 
	- Initial Deployment OK
	- Get configs NO bad event hub conn strings

2-DataWarehouse - OK
	- Go into portal, database, firewall, and add your IP adress
	- Click Add client IP, and you might reduce by 1 Start IP
	- Scripts should be marked as Embedded Resources

3-DataLakeAnalytics
	- Create AzureAD application - maybe will survive without this since stream analytics need to click authorize anyways
	- Copy data

4-DataFactory
	- So far VS plugis is so bad, that I go straight with json files and powershell

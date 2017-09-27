using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DataWarehouseDbUp.Extensions.AzureSqlDw;
using System.Configuration;
using System.Reflection;
using DbUp;

namespace DataWarehouseDbUp
{
    class Program
    {
        static int Main(string[] args)
        {
            var connectionString = GetDbConnString();

            //Data Warehouse upgrader
            //DeployChanges.To
            //        .AzureSqlDwDatabase(connectionString)

            //Regular SQL DB
            //DeployChanges.To
            //        .SqlDatabase(connectionString)

            var upgrader =
                DeployChanges.To
                    .AzureSqlDwDatabase(connectionString)
                    .WithScriptsEmbeddedInAssembly(Assembly.GetExecutingAssembly())
                    .LogToConsole()
                    .Build();

            var result = upgrader.PerformUpgrade();

            if (!result.Successful)
            {
                Console.ForegroundColor = ConsoleColor.Red;
                Console.WriteLine(result.Error);
                Console.ResetColor();
#if DEBUG
                Console.ReadLine();
#endif
                return -1;
            }

            Console.ForegroundColor = ConsoleColor.Green;
            Console.WriteLine("Success!");
            Console.ResetColor();
            return 0;

        }

        static string GetDbConnString()
        {
            var databaseName = ConfigurationManager.AppSettings["DatabaseName"];
            var serverName = ConfigurationManager.AppSettings["SqlDmServerInstance"];
            var databaseUser = ConfigurationManager.AppSettings["DatabaseUser"];
            var databasePassword = ConfigurationManager.AppSettings["DatabasePassword"];

            var connectionString =
                string.Format("Server=tcp:{0}.database.windows.net,1433;Initial Catalog={1};Integrated Security=False;User ID={2}@{0};Password={3};Connect Timeout=60;Encrypt=True",
                    serverName,
                    databaseName,
                    databaseUser,
                    databasePassword
                );

            return connectionString;

        }
    }
}

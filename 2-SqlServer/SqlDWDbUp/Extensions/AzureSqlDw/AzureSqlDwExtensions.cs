using DbUp;
using DbUp.Builder;
using DbUp.Engine.Output;
using DbUp.Engine.Transactions;
using DbUp.Support.SqlServer;
using DataWarehouseDbUp.Extensions.AzureSqlDw;

/// <summary>
/// Configuration extension methods for SQL Server.
/// </summary>
// NOTE: DO NOT MOVE THIS TO A NAMESPACE
// Since the class just contains extension methods, we leave it in the root so that it is always discovered
// and people don't have to manually add using statements.
// ReSharper disable CheckNamespace
public static class AzureSqlDwExtensions
// ReSharper restore CheckNamespace
{
    /// <summary>
    /// Creates an upgrader for Azure SQL Data Warehouse database.
    /// </summary>
    /// <param name="supported">Fluent helper type.</param>
    /// <param name="connectionString">The connection string.</param>
    /// <returns>
    /// A builder for a database upgrader designed for Azure SQL Data Warehouse database.
    /// </returns>
    public static UpgradeEngineBuilder AzureSqlDwDatabase(this SupportedDatabases supported, string connectionString)
    {
        return AzureSqlDwDatabase(supported, connectionString, null);
    }

    /// <summary>
    /// Creates an upgrader for Azure SQL Data Warehouse database.
    /// </summary>
    /// <param name="supported">Fluent helper type.</param>
    /// <param name="connectionString">The connection string.</param>
    /// <param name="schema">The SQL schema name to use. Defaults to 'dbo'.</param>
    /// <returns>
    /// A builder for a database upgrader designed for Azure SQL Data Warehouse database.
    /// </returns>
    public static UpgradeEngineBuilder AzureSqlDwDatabase(this SupportedDatabases supported, string connectionString, string schema)
    {
        return AzureSqlDwDatabase(new SqlConnectionManager(connectionString), schema);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="connectionManager"></param>
    /// <param name="schema"></param>
    /// <returns></returns>
    private static UpgradeEngineBuilder AzureSqlDwDatabase(IConnectionManager connectionManager, string schema)
    {
        var builder = new UpgradeEngineBuilder();
        builder.Configure(c => c.ConnectionManager = connectionManager);
        builder.Configure(c => c.ScriptExecutor = new SqlScriptExecutor(() => c.ConnectionManager, () => c.Log, schema, () => c.VariablesEnabled, c.ScriptPreprocessors));
        builder.Configure(c => c.Journal = new AzureSqlDwTableJournal(() => c.ConnectionManager, () => c.Log, schema, "SchemaVersions"));
        return builder;
    }

    /// <summary>
    /// Tracks the list of executed scripts in a SQL Server table.
    /// </summary>
    /// <param name="builder">The builder.</param>
    /// <param name="schema">The schema.</param>
    /// <param name="table">The table.</param>
    /// <returns></returns>
    public static UpgradeEngineBuilder JournalToAzureDwTable(this UpgradeEngineBuilder builder, string schema, string table)
    {
        builder.Configure(c => c.Journal = new AzureSqlDwTableJournal(() => c.ConnectionManager, () => c.Log, schema, table));
        return builder;
    }

    /// <summary>
    /// Ensures that the database specified in the connection string exists.
    /// </summary>
    /// <param name="supported">Fluent helper type.</param>
    /// <param name="connectionString">The connection string.</param>
    /// <returns></returns>
    public static void AzureSqlDwDatabase(this SupportedDatabasesForEnsureDatabase supported, string connectionString)
    {
        SqlServerExtensions.SqlDatabase(supported, connectionString, new ConsoleUpgradeLog());
    }

    /// <summary>
    /// Ensures that the database specified in the connection string exists.
    /// </summary>
    /// <param name="supported">Fluent helper type.</param>
    /// <param name="connectionString">The connection string.</param>
    /// <param name="commandTimeout">Use this to set the command time out for creating a database in case you're encountering a time out in this operation.</param>
    /// <returns></returns>
    public static void AzureSqlDwDatabase(this SupportedDatabasesForEnsureDatabase supported, string connectionString, int commandTimeout)
    {
        SqlServerExtensions.SqlDatabase(supported, connectionString, new ConsoleUpgradeLog(), commandTimeout);
    }
}
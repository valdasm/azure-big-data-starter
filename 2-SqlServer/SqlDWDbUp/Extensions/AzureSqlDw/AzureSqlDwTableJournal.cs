using System;
using DbUp.Engine.Output;
using DbUp.Engine.Transactions;
using DbUp.Support.SqlServer;

namespace DataWarehouseDbUp.Extensions.AzureSqlDw
{
    /// <summary>
    /// An implementation of the <see cref="IJournal"/> interface which tracks version numbers for a 
    /// SQL Server database using a table called dbo.SchemaVersions.
    /// </summary>
    public class AzureSqlDwTableJournal : SqlTableJournal
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="AzureSqlDwTableJournal"/> class.
        /// </summary>
        public AzureSqlDwTableJournal(
            Func<IConnectionManager> connectionManager,
            Func<IUpgradeLog> logger,
            string schema,
            string table) :
            base(connectionManager, logger, schema, table)
        {
        }

        /// <summary>Generates an SQL statement that, when exectuted, will create the journal database table.</summary>
        /// <param name="schema">Desired schema name supplied by configuration or <c>NULL</c></param>
        /// <param name="table">Desired table name</param>
        /// <returns>A <c>CREATE TABLE</c> SQL statement</returns>
        protected override string CreateTableSql(string schema, string table)
        {
            var tableName = CreateTableName(schema, table);
            //var primaryKeyConstraintName = CreatePrimaryKeyName(table);

            return string.Format(@"create table {0} 
                                   (
	                                   [Id] int identity(1,1) not null,
	                                   [ScriptName] nvarchar(255) not null,
	                                   [Applied] datetime not null
                                   )",
                                    tableName);
        }
    }
}
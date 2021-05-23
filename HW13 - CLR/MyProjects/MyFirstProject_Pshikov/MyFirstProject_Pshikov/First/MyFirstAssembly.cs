using Microsoft.SqlServer.Server;
using System.Data;
using System.Data.SqlTypes;

namespace WWI_Pshikov_Namespace
{
    // CLR-процедуры, функции должны быть публичными статическими методами

    public class WWI_Pshikov_Class
    {
        public static SqlDouble MyExponentiation(SqlDouble number, SqlInt32 extent)
        {
            SqlInt32  Schetchik = 1;
            SqlDouble result    = 1;

            while (Schetchik <= extent)
            {
                result = result * number;
                Schetchik += 1;
            }

            return result;
        }

        public static void MyHelloProcedure(SqlString name, SqlInt32 number)
        {
            var pipe = SqlContext.Pipe;

            var columns     = new SqlMetaData[2];
                columns[0]  = new SqlMetaData("НомерСтроки", SqlDbType.NVarChar, 100);
                columns[1]  = new SqlMetaData("Приветствие", SqlDbType.NVarChar, 500);

            var row = new SqlDataRecord(columns);
            pipe.SendResultsStart(row);
            for (int i = 0; i < number; i++)
            {
                row.SetSqlString(0, string.Format("Строка №{0} ", i));
                row.SetSqlString(1, string.Format("Добрый день, уважаемый {0}", name));
                pipe.SendResultsRow(row);
            }

            pipe.SendResultsEnd();
        }
    }
}
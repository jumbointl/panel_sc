import 'package:postgres/postgres.dart';
import 'package:solexpress_panel_sc/src/providers/provider_model.dart';

import '../../../../../data/memory_panel_sc.dart';

class PostgresProviderModel extends ProviderModel {
  Future<Result?> connectToPostgresAndExecuteQuery(String query) async{

    String host = MemoryPanelSc.attendanceDbHost;
    String dbName = MemoryPanelSc.attendanceDbName;
    int dbPort = MemoryPanelSc.attendanceDbPort;
    String dbUser = MemoryPanelSc.attendanceDbUser;
    String dbPassword = MemoryPanelSc.attendanceDbPassword;
    late Result result;
    late Connection conn;

    try {
        conn = await Connection.open(
        Endpoint(
          host: host,
          database: dbName,
          username: dbUser,
          password: dbPassword,
          port: dbPort,
        ),
        // The postgres server hosted locally doesn't have SSL by default. If you're
        // accessing a postgres server over the Internet, the server should support
        // SSL and you should swap out the mode with `SslMode.verifyFull`.
        settings: ConnectionSettings(sslMode: SslMode.require),
      );
      result = await conn.execute(query);
      print('result.affectedRows      ${result.affectedRows ?? 'null'}');
      print('result          ${result.toString()}');
      return result ;

    } catch (e) {
      print('Error connecting to PostgresSQL: $e');
      return null;
      // Return false or throw an exception as per your error handling strategy
    } finally{
      await conn.close();
    }

  }
  Future<List<Result>> connectToPostgresAndExecuteMultipleQueriesInTransaction(List<String> queries) async {
    String host = MemoryPanelSc.attendanceDbHost;
    String dbName = MemoryPanelSc.attendanceDbName;
    int dbPort = MemoryPanelSc.attendanceDbPort;
    String dbUser = MemoryPanelSc.attendanceDbUser;
    String dbPassword = MemoryPanelSc.attendanceDbPassword;
    late List<Result> results =[];
    late Connection conn;

    try {
      conn = await Connection.open(
        Endpoint(
          host: host,
          database: dbName,
          username: dbUser,
          password: dbPassword,
          port: dbPort,
        ),
        // The postgres server hosted locally doesn't have SSL by default. If you're
        // accessing a postgres server over the Internet, the server should support
        // SSL and you should swap out the mode with `SslMode.verifyFull`.
        settings: ConnectionSettings(sslMode: SslMode.require),
      );
      await conn.runTx((ctx) async {
        for (int i = 0; i < queries.length; i++) {
          print(queries[i]);
          Result result = await ctx.execute(queries[i]);
          results.add(result);
        }
        // If this query fails, the previous two will be rolled back
        // await ctx.query("INSERT INTO non_existent_table (col) VALUES (1);");
      });
      print('Transaction successful.');
      return results;
    } catch (e) {
      print('Transaction failed: $e');
      return results;
    } finally {
      await conn.close();
    }
  }
}
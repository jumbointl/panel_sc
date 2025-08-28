import 'package:sqflite/sqflite.dart';
import 'package:postgres/postgres.dart';
import 'package:path/path.dart';

import '../../data/memory_panel_sc.dart';
import '../../models/attendance.dart';

class DatabaseEventPanel {
  static final DatabaseEventPanel _instance = DatabaseEventPanel._internal();

  factory DatabaseEventPanel() => _instance;

  DatabaseEventPanel._internal();

  static final String TABLE_SCANNED = MemoryPanelSc.TABLE_SCANNED;
  static const String COLUMN_QR = 'qr';
  static const String COLUMN_PROCESSED = 'processed';
  static const String COLUMN_PLACE_ID = 'place_id';
  static const String COLUMN_ID = 'id';

  static final String DB_NAME = MemoryPanelSc.DB_NAME;


  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = await getDatabasesPath();
    String dbPath = join(path, DB_NAME);
    String tableScanned = TABLE_SCANNED;
    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          '''CREATE TABLE $tableScanned(
          $COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT,
          $COLUMN_QR TEXT NOT NULL UNIQUE, 
          $COLUMN_PLACE_ID INTEGER NOT NULL, 
          $COLUMN_PROCESSED INTEGER DEFAULT 0)
          ''',
        );
        // You can add more CREATE TABLE statements for other tables here
      },
      onUpgrade: (db, oldVersion, newVersion) {
        // Handle database schema migrations here if needed
      },
    );
  }

  Future<int?> insertIntoScanned(Database db, String scanned) async {
    if (scanned.length < MemoryPanelSc.lengthBarcode) {
      return null;
    }
    int? placeId = int.tryParse(
        scanned.substring(0, MemoryPanelSc.lengthPlaceId));
    if (placeId == null) {
      return null;
    }

    Map<String, dynamic> data = {
      COLUMN_QR: scanned,
      COLUMN_PLACE_ID: placeId,
    };

    print(data);
    try {
      int id = await db.insert(
        TABLE_SCANNED,
        data,
        conflictAlgorithm: ConflictAlgorithm.rollback,
      );



      return id;
    } catch (e) {
      print('Error inserting into $TABLE_SCANNED: $e');
      return null;
    }

  }
  Future<List<Attendance>?> insertIntoScannedAndGetUnprocessedData(Database db, String scanned) async {
    if (scanned.length < MemoryPanelSc.lengthBarcode) {
      return null;
    }
    int? placeId = int.tryParse(
        scanned.substring(scanned.length - MemoryPanelSc.lengthPlaceId));
    if (placeId == null) {
      return null;
    }

    Map<String, dynamic> data = {
      COLUMN_QR: scanned,
      COLUMN_PLACE_ID: placeId,
    };


    await db.insert(
      TABLE_SCANNED, // Your table name
      data,
      conflictAlgorithm: ConflictAlgorithm
          .rollback, // Example conflict resolution
    );
    final List<Map<String, dynamic>> result = await db.rawQuery(
        "SELECT * FROM $TABLE_SCANNED WHERE $COLUMN_PROCESSED = 0");
    if (result.isNotEmpty) {
      List<Attendance> attendanceList = Attendance.fromJsonList(result);
      return attendanceList; // Return 0 if the count is null
    }
    return [];
  }

  Future<int> getUnprocessedCount() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery("SELECT COUNT(*) FROM $TABLE_SCANNED WHERE $COLUMN_PROCESSED = 0");
    if (result.isNotEmpty) {
      // The COUNT result is typically in the first row and first column of the map.
      // The key might be 'COUNT(*)' or similar depending on the SQLite version,
      // but Sqflite.firstIntValue is a convenient way to extract it.
      return Sqflite.firstIntValue(result) ?? 0; // Return 0 if the count is null
    }
    return 0;
  }
  Future<List<Attendance>> getUnprocessedAttendance() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery(
        "SELECT * FROM $TABLE_SCANNED WHERE $COLUMN_PROCESSED = 0");
    if (result.isNotEmpty) {
      List<Attendance> attendanceList = Attendance.fromJsonList(result);
      return attendanceList; // Return 0 if the count is null
    }
    return <Attendance>[];
  }
  Future<void> updateAttendancesToProcessed(List<Attendance> attendances) async {
    if (attendances.isEmpty) {
      return;
    }
    final db = await database;
    String whereClause = '$COLUMN_QR IN (';
    for (int i = 0; i < attendances.length-1; i++) {
      whereClause =  "$whereClause '${attendances[i].qr}',";
    }
    whereClause = "$whereClause '${attendances[attendances.length-1].qr}')";
    print(whereClause);
    await db.rawUpdate("UPDATE $TABLE_SCANNED SET $COLUMN_PROCESSED = 1 WHERE $whereClause");
    print('updateAttendancesToProcessed');

  }
  Future<List<Attendance>?> getUnprocessedAttendanceAndSendToServer() async {
    // Return unprocessed attendances from the database
    final db = await database;
    final List<Map<String, dynamic>> attendances = await db.rawQuery(
        "SELECT * FROM $TABLE_SCANNED WHERE $COLUMN_PROCESSED = 0");
    if (attendances.isNotEmpty) {
      List<Attendance> attendanceList = Attendance.fromJsonList(attendances);
      String query = 'INSERT INTO attendance (qr,place_id) VALUES ';
      for (int i = 0; i < attendanceList.length-1; i++) {
        query = "$query ('${attendanceList[i].qr}',${attendanceList[i].placeId}),";
      }
      query = "$query ('${attendanceList[attendanceList.length-1].qr}',${attendanceList[attendanceList.length-1].placeId})";
      query = "$query RETURNING id";
      print(query);
      String host = MemoryPanelSc.attendanceDbHost;
      String dbName = MemoryPanelSc.attendanceDbName;
      int dbPort = MemoryPanelSc.attendanceDbPort;
      String dbUser = MemoryPanelSc.attendanceDbUser;
      String dbPassword = MemoryPanelSc.attendanceDbPassword;


      try {
        final conn = await Connection.open(
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
        print('try new connection..');

        final results = await conn.execute(query);
        for (int i = 0; i < results.length; i++) {
          print('result     ${results[i]}');
        }

        conn.close();
        List<int> resultIds =<int>[];
        if (results.isNotEmpty && results.first.isNotEmpty) {

          for(int i = 0; i < results.length; i++){
            var row = results[i];
            if(row[0] !=null ){
              int id = row[0] as int ?? 0;
              resultIds.add(id);
            }

          }

          print('result     ${resultIds.length}');
          String whereClause = '$COLUMN_QR IN (';
          for (int i = 0; i < attendances.length-1; i++) {
            whereClause =  "$whereClause '${attendanceList[i].qr}',";
          }
          whereClause = "$whereClause '${attendanceList[attendances.length-1].qr}')";
          print(whereClause);
          await db.rawDelete("DELETE FROM $TABLE_SCANNED WHERE $whereClause");
          print('deletedProcessedAttendances');
          for (Attendance attendance in attendanceList) {
            attendance.processed = 1;
          }
          final List<Map<String, dynamic>> result = await db.rawQuery(
              "SELECT * FROM $TABLE_SCANNED WHERE $COLUMN_PROCESSED = 0");
          if (result.isNotEmpty) {
            List<Attendance> attendanceList = Attendance.fromJsonList(result);
            return attendanceList; // Return 0 if the count is null
          } else {
            return <Attendance>[];
          }

        }
        return <Attendance>[];

      } catch (e) {
        print('Error connecting to PostgreSQL: $e');
        return null;
      }


    }
    return <Attendance>[];
  }

}
import 'package:digitalbibleapp/constants.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NtProvider {
  static NtProvider _ntProvider;
  static Database _database;

  final String _dbName = Constants.notesDbname;
  final String _tableName = 'notes';

  NtProvider._createInstance();

  factory NtProvider() {
    _ntProvider ??= NtProvider._createInstance();
    return _ntProvider;
  }

  Future<Database> get database async {
    _database ??= await initDB();
    return _database;
  }

  Future<Database> initDB() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, _dbName);

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) async {},
      onCreate: (Database db, int version) async {
        // Create the note table
        await db.execute('''
                CREATE TABLE $_tableName(
                    id INTEGER PRIMARY KEY,
                    time INTEGER DEFAULT 0,
                    contents TEXT DEFAULT ''
                )
            ''');
      },
    );
  }

  Future close() async {
    return _database.close();
  }
}

import 'dart:async';
import 'package:digitalbibleapp/bmarks/bmModel.dart';
import 'package:digitalbibleapp/constants.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// Bookmarks database helper

class BmProvider {
  final String _dbName = Constants.bmksDbname;
  final String _dbTable = 'bmks_table';

  static BmProvider _dbProvider;
  static Database _database;

  BmProvider._createInstance();

  factory BmProvider() {
    _dbProvider ??= BmProvider._createInstance();
    return _dbProvider;
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
        await db.execute('''
                CREATE TABLE IF NOT EXISTS $_dbTable (
                    id INTEGER PRIMARY KEY,
                    title TEXT DEFAULT '',
                    subtitle TEXT DEFAULT '',
                    version INTEGER DEFAULT 0,
                    book INTEGER DEFAULT 0,
                    chapter INTEGER DEFAULT 0,
                    verse INTEGER DEFAULT 0
                )
            ''');
      },
    );
  }

  Future close() async {
    return _database.close();
  }
}

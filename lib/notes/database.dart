// @dart=2.9

import 'package:digitalbibleapp/notes/model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// Notes database helper

class NDProvider {
  final String _dbName = 'dba_notes.db';
  final String _tableName = 'notes';
  final int _databaseVersion = 1;

  NDProvider();

  //NDProvider._();

  static final NDProvider db = NDProvider();
  Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await initDB();
    return _database;
  }

  Future close() async {
    return _database.close();
  }

  Future<Database> initDB() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, _dbName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onOpen: (db) async {},
      onCreate: (Database db, int version) async {
        // Create the note table
        await db.execute('''
                CREATE TABLE $_tableName(
                    id INTEGER PRIMARY KEY,
                    time INTEGER DEFAULT 0,
                    title TEXT DEFAULT '',
                    subtitle TEXT DEFAULT ''
                )
            ''');
      },
    );
  }

  Future<int> insertNote(NModel model) async {
    final db = await database;
    return await db.insert(_tableName, model.toJson());
  }

  Future<int> updateNote(NModel model) async {
    final db = await database;
    return await db.update(_tableName, model.toJson(),
        where: 'id = ?', whereArgs: [model.id]);
  }

  Future<List<NModel>> getAllNotes() async {
    final db = await database;
    var res = await db.query(_tableName, orderBy: 'time DESC');
    List<NModel> notes = res.isNotEmpty
        ? res.map((_tableName) => NModel.fromJson(_tableName)).toList()
        : [];
    return notes;
  }

  Future<int> deleteNote(int id) async {
    final db = await database;
    return await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> getNoteCount() async {
    final db = await database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $_tableName'));
  }
}

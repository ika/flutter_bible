import 'dart:async';
import 'dart:io';
import 'package:digitalbibleapp/constants.dart';
import 'package:digitalbibleapp/globals.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

String getBVFileName(int v) {
  String _dbName = '';
  switch (v) {
    case 1:
      _dbName = Constants.kjvbDbname;
      break;
    case 2:
      _dbName = Constants.clemDbname;
      break;
    case 3:
      _dbName = Constants.cpdvDbname;
      break;
    case 4:
      _dbName = Constants.nvulDbname;
      break;
    case 5:
      _dbName = Constants.af53Dbname;
      break;
    case 6:
      _dbName = Constants.dn33Dbname;
      break;
    case 7:
      _dbName = Constants.ukjvDbname;
      break;
    case 8:
      _dbName = Constants.webbDbname;
      break;
    case 9:
      _dbName = Constants.af83Dbname;
      break;
    case 10:
      _dbName = Constants.asvbDbname;
      break;
  }
  return _dbName;
}

class DbProvider {
  static String _bibleDbName;
  static DbProvider _dbProvider;
  static Database _database;

  DbProvider._createInstance();

  factory DbProvider() {
    _bibleDbName = getBVFileName(Globals.bibleVersion);

    // print('DbProvider VERSION = ' + Globals.v.toString());
    // print('DbProvider bibleDbName = ' + _bibleDbName);

    _dbProvider ??= DbProvider._createInstance();
    return _dbProvider;
  }

  Future<Database> get database async {
    //_database ??= await initDB();
    _database = await initDB();
    return _database;
  }

  Future<Database> initDB() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, _bibleDbName);

    if (!(await databaseExists(path))) {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", _bibleDbName));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(path).writeAsBytes(bytes, flush: true);
    }

    return await openDatabase(path);
  }

  Future close() async {
    return _database.close();
  }
}

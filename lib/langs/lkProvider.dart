import 'dart:async';
import 'dart:io';

import 'package:digitalbibleapp/constants.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// Language Key Provider

class LkProvider {
  final String _dbName = Constants.lkeyDbname;

  static LkProvider _lkProvider;
  static Database _database;

  LkProvider._createInstance();

  factory LkProvider() {
    _lkProvider ??= LkProvider._createInstance();
    return _lkProvider;
  }

  Future<Database> get database async {
    _database ??= await initDB();
    return _database;
  }

  Future<Database> initDB() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, _dbName);

    var exists = await databaseExists(path);

    if (!exists) {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      ByteData data = await rootBundle.load(join("assets", _dbName));
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

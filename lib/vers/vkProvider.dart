import 'dart:async';
import 'dart:io';

import 'package:digitalbibleapp/constants.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// Version Key helper

class VkProvider {
  final String _dbName = Constants.vkeyDbname;

  static VkProvider _vkProvider;
  static Database _database;

  VkProvider._createInstance();

  factory VkProvider() {
    _vkProvider ??= VkProvider._createInstance();
    return _vkProvider;
  }

  Future<Database> get database async {
    _database ??= await initDB();
    return _database;
  }

  Future<Database> initDB() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, _dbName);

    if (!(await databaseExists(path))) {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
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

import 'dart:async';

import 'package:digitalbibleapp/globals.dart';
import 'package:digitalbibleapp/vers/vkProvider.dart';
import 'package:digitalbibleapp/vers/vkModel.dart';
import 'package:sqflite/sqflite.dart';

// Version Key queries

VkProvider _vkProvider;

class VkQueries {
  final String _dbTable = 'version_key';

  VkQueries() {
    _vkProvider = VkProvider();
  }

  Future<int> getActiveVerCount() async {
    final db = await _vkProvider.database;
    int count = Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM $_dbTable WHERE active='1'"));
    return count;
  }

  Future<void> updateActiveState(int a, int i) async {
    final db = await _vkProvider.database;
    await db.rawUpdate("UPDATE $_dbTable SET active=$a WHERE number=$i");
  }

  Future<List<VkModel>> getAllVkVersions() async {
    final db = await _vkProvider.database;

    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM $_dbTable WHERE number <>${Globals.bibleVersion}");

    return List.generate(
      maps.length,
      (i) {
        return VkModel(
          i: maps[i]['id'],
          n: maps[i]['number'],
          // bible version number
          a: maps[i]['active'],
          // active
          r: maps[i]['abbr'],
          // abbreviation
          l: maps[i]['lang'],
          // language
          m: maps[i]['name'], // version name
        );
      },
    );
  }

  Future<List<VkModel>> getActiveVersions() async {
    final db = await _vkProvider.database;

    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM $_dbTable WHERE active='1' AND number <>${Globals.bibleVersion}");

    return List.generate(
      maps.length,
      (i) {
        return VkModel(
          i: maps[i]['id'],
          n: maps[i]['number'],
          // bible version number
          a: maps[i]['active'],
          // active
          r: maps[i]['abbr'],
          // abbreviation
          l: maps[i]['lang'],
          // language
          m: maps[i]['name'], // version name
        );
      },
    );
  }

  Future<List<VkModel>> getVersionKey(int n) async {
    final db = await _vkProvider.database;

    final List<Map<String, dynamic>> maps =
        await db.rawQuery("SELECT * FROM $_dbTable WHERE number=$n");

    return List.generate(
      maps.length,
      (i) {
        return VkModel(
          i: maps[i]['id'],
          n: maps[i]['number'],
          // bible version number
          a: maps[i]['active'],
          // active
          r: maps[i]['abbr'],
          // abbreviation
          l: maps[i]['lang'],
          // language
          m: maps[i]['name'], // version name
        );
      },
    );
  }
}

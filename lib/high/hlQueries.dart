import 'dart:async';
import 'package:digitalbibleapp/bmarks/bmModel.dart';
import 'package:digitalbibleapp/high/hlModel.dart';
import 'package:digitalbibleapp/high/hlProvider.dart';
import 'package:sqflite/sqflite.dart';

// Bookmarks database helper

HlProvider _hlProvider;

class HlQueries {
  final String _dbTable = 'hlts_table';

  HlQueries() {
    _hlProvider = HlProvider();
  }

  Future<int> saveHighLight(HlModel model) async {
    final db = await _hlProvider.database;
    return await db.insert(
      // retuns the insert id
      _dbTable,
      model.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> deleteHighLight(int id) async {
    final db = await _hlProvider.database;
    return await db.delete(_dbTable, where: "id = ?", whereArgs: [id]);
  }

  Future<List<HlModel>> getHighLightList() async {
    final db = await _hlProvider.database;
    final List<Map<String, dynamic>> maps =
        await db.rawQuery("SELECT * FROM $_dbTable ORDER BY id DESC");

    return List.generate(
      maps.length,
      (i) {
        return HlModel(
            id: maps[i]['id'],
            title: maps[i]['title'],
            subtitle: maps[i]['subtitle'],
            version: maps[i]['version'],
            book: maps[i]['book'],
            chapter: maps[i]['chapter'],
            verse: maps[i]['verse']);
      },
    );
  }
}

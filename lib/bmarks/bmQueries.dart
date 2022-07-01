import 'dart:async';
import 'package:digitalbibleapp/bmarks/bmModel.dart';
import 'package:digitalbibleapp/bmarks/bmProvider.dart';
import 'package:sqflite/sqflite.dart';

// Bookmarks database helper

BmProvider _bmProvider;

class BmQueries {
  final String _dbTable = 'bmks_table';

  BmQueries() {
    _bmProvider = BmProvider();
  }

  Future<int> saveBookMark(BmModel model) async {
    final db = await _bmProvider.database;
    return await db.insert(
      // retuns the insert id
      _dbTable,
      model.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> deleteBookMark(int id) async {
    final db = await _bmProvider.database;
    return await db.delete(_dbTable, where: "id = ?", whereArgs: [id]);
  }

  Future<List<BmModel>> getBookMarkList() async {
    final db = await _bmProvider.database;
    final List<Map<String, dynamic>> maps =
        await db.rawQuery("SELECT * FROM $_dbTable ORDER BY id DESC");

    return List.generate(
      maps.length,
      (i) {
        return BmModel(
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

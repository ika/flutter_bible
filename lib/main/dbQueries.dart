import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:digitalbibleapp/main/dbModel.dart';
import 'package:digitalbibleapp/main/dbProvider.dart';

// Bible database queries

DbProvider _dbProvider;

class DbQueries {
  final String _dbTable = 't_bible';

  DbQueries() {
    _dbProvider = DbProvider();
  }

  // Get whole book
  Future<List<Bible>> getBookChapter(int b, int c) async {
    final db = await _dbProvider.database;

    final List<Map<String, dynamic>> maps =
        await db.rawQuery("SELECT * FROM $_dbTable WHERE b=$b AND c=$c");

    List<Bible> values = List.generate(
      maps.length,
      (i) {
        return Bible(
          i: maps[i]['id'],
          b: maps[i]['b'],
          c: maps[i]['c'],
          v: maps[i]['v'],
          t: maps[i]['t'],
        );
      },
    );
    return values;
  }

  Future<int> getChapterCount(int b) async {
    final db = await _dbProvider.database;

    int count = Sqflite.firstIntValue(
        await db.rawQuery("SELECT MAX(c) FROM $_dbTable WHERE b=$b"));
    return count;
  }

    Future<int> getVerseCount(int b, int c) async {
    final db = await _dbProvider.database;

    int count = Sqflite.firstIntValue(
        await db.rawQuery("SELECT MAX(v) FROM $_dbTable WHERE b=$b AND c=$c"));
    return count;
  }
}

// @Query("SELECT * FROM t_bible WHERE b=:book AND c=:chap")
// LiveData<List<BiblesEntities>> getBookAndChapter(int book, int chap);

// @Query("SELECT MAX(v) FROM t_bible WHERE b=:book AND c=:chap")
// int getVerseCount(int book, int chap);

// @Query("SELECT MAX(c) FROM t_bible WHERE b=:book")
// int getChapterCount(int book);

// @Query("SELECT * FROM t_bible WHERE t LIKE '%' || :query || '%' AND b BETWEEN :start AND :end ORDER BY b ASC")
// List<BiblesEntities> bibleSearch(String query, int start, int end);

// @Query("SELECT * FROM t_bible WHERE b=:book AND c=:chap AND v=:verse")
// List<BiblesEntities> getCompareValues(int book, int chap, int verse);

// @Query("SELECT t FROM t_bible WHERE b=:book AND c=:chap AND v=:verse")
// Cursor getDataProviderValues(int book, int chap, int verse);

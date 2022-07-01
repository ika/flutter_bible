import 'dart:async';

import 'package:digitalbibleapp/langs/lkModel.dart';
import 'package:digitalbibleapp/langs/lkProvider.dart';

// Language Key queries

LkProvider _lkProvider;

class LkQueries {
  final String _dbTable = 'language_key';

  LkQueries() {
    _lkProvider = LkProvider();
  }

  // Get whole book
  Future<List<LKey>> getBookName(int b, String l) async {
    final db = await _lkProvider.database;

    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM '$_dbTable' WHERE number='$b' AND code='$l'"); // raw query strings must be enclosed

    return List.generate(
      maps.length,
      (i) {
        return LKey(
          i: maps[i]['id'],
          b: maps[i]['number'], // book number
          l: maps[i]['code'], // language code
          n: maps[i]['name'], // book name
        );
      },
    );
  }
}

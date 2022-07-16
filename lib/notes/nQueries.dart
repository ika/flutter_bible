import 'package:digitalbibleapp/notes/model.dart';
import 'package:digitalbibleapp/notes/nProvider.dart';
import 'package:sqflite/sqflite.dart';

NtProvider _ntProvider;

class NtQueries {
  final String _tableName = 'notes';

  NtQueries() {
    _ntProvider = NtProvider();
  }

  Future<int> insertNote(NtModel model) async {
    final db = await _ntProvider.database;
    return await db.insert(_tableName, model.toJson());
  }

  Future<int> updateNote(NtModel model) async {
    final db = await _ntProvider.database;
    return await db.update(_tableName, model.toJson(),
        where: 'id = ?', whereArgs: [model.id]);
  }

  Future<List<NtModel>> getAllNotes() async {
    final db = await _ntProvider.database;
    var res = await db.query(_tableName, orderBy: 'time DESC');
    List<NtModel> notes = res.isNotEmpty
        ? res.map((_tableName) => NtModel.fromJson(_tableName)).toList()
        : [];
    return notes;
  }

  Future<int> deleteNote(int id) async {
    final db = await _ntProvider.database;
    return await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> getNoteCount() async {
    final db = await _ntProvider.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $_tableName'));
  }
}
